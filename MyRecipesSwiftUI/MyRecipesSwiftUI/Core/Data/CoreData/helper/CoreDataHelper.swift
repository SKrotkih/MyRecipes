//
//  CoreDataHelper.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import CoreData

class CoreDataHelper {
    static let context = PersistenceController.shared.container.viewContext
    
    func fetchFakeRecipes() {
        let FakeDataFileName = "recipes"
        do {
            let data = try readJSONFile(FakeDataFileName)
            let myRecipesContainer = try JSONDecoder().decode(RecipesContainer.self, from: data!)
            if let recipes = myRecipesContainer.recipes {
                for var recipe in recipes {
                    recipe.toManagedObject(context: CoreDataHelper.context)
                }
            }
            save()
        } catch let ReadingJsonError.fileNameError(message) {
            fatalError(message)
        } catch {
            fatalError("error: \(error)")
        }
    }
    
    func deleteRecipe(_ recipe: Recipe, context: NSManagedObjectContext = CoreDataHelper.context) {
        recipe.delete(context: context)
    }

    func markRecipeAsVavorite(_ recipe: Recipe, context: NSManagedObjectContext = CoreDataHelper.context) {
        recipe.update({ recipeEntity in
            recipeEntity.favorite.toggle()
        }, context: context)
    }

    func save(context: NSManagedObjectContext = CoreDataHelper.context) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            fatalError("Unresolved error \(error.localizedDescription)")
        }
    }
}
