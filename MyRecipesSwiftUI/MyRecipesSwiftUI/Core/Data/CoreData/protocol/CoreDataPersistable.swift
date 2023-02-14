//
//  CoreDataPersistable.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import CoreData

protocol UUIDIdentifiable: Identifiable {
    var id: String { get set }
}

protocol CoreDataPersistable: UUIDIdentifiable {
    associatedtype ManagedType
    init()
    init(managedObject: ManagedType?)
    var keyMap: [PartialKeyPath<Self>: String] { get }
    mutating func toManagedObject(context: NSManagedObjectContext) -> ManagedType

    func fetchManagedObject(context: NSManagedObjectContext) -> ManagedType?
    func update(_ closure: (ManagedType) -> Void, context: NSManagedObjectContext)
    func delete(context: NSManagedObjectContext)
    func save(context: NSManagedObjectContext)
}

extension CoreDataPersistable where ManagedType: NSManagedObject {
    init(managedObject: ManagedType?) {
        self.init()
        guard let managedObject = managedObject else { return }
        for attribute in managedObject.entity.attributesByName {
            if let keyP = keyMap.first(where: { $0.value == attribute.key })?.key,
               let value = managedObject.value(forKey: attribute.key) {
                storeValue(value, toKeyPath: keyP)
            }
        }
    }
    
    private mutating func storeValue(_ value: Any, toKeyPath partial: AnyKeyPath) {
        switch partial {
        case let keyPath as WritableKeyPath<Self, URL>:
            self[keyPath: keyPath] = value as! URL
        case let keyPath as WritableKeyPath<Self, Int>:
            self[keyPath: keyPath] = value as! Int
        case let keyPath as WritableKeyPath<Self, String>:
            self[keyPath: keyPath] = value as! String
        case let keyPath as WritableKeyPath<Self, Bool>:
            self[keyPath: keyPath] = value as! Bool
        default:
            return
        }
    }
    
    mutating func toManagedObject(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> ManagedType {
        let persistedValue: ManagedType
        if let managedObject = fetchManagedObject(context: context) {
            persistedValue = managedObject
        } else {
            persistedValue = ManagedType.init(context: context)
        }
        return setValuesFromMirror(persistedValue: persistedValue)
    }
    
    private func setValuesFromMirror(persistedValue: ManagedType) -> ManagedType {
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            let value2 = Mirror(reflecting: value)
            if value2.displayStyle != .optional || !value2.children.isEmpty {
                persistedValue.setValue(value, forKey: label)
            }
        }
        return persistedValue
    }
}

extension CoreDataPersistable where ManagedType: NSManagedObject {
    func fetchManagedObject(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> ManagedType? {
        let fetchRequest = ManagedType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        if let results = try? context.fetch(fetchRequest),
           let firstResult = results.first as? ManagedType {
            return firstResult
        } else {
            return nil
        }
    }

    func update(_ closure: (ManagedType) -> Void, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        if let managedObject = fetchManagedObject(context: context) {
            closure(managedObject)
            self.save(context: context)
        }
    }
    
    func delete(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        if let managedObject = fetchManagedObject(context: context) {
            context.delete(managedObject)
            self.save(context: context)
        }
    }
    
    func save(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            fatalError("Unresolved error \(error.localizedDescription)")
        }
    }
}
