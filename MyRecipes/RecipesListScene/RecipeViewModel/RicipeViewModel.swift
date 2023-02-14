//
//  RicipeViewModel.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import UIKit
import Combine

struct ReceipeData {
    let title: String?
    let image: UIImage?
    let description: String?
}

class RecipeViewModel {
    
    var isDataUpdated = PassthroughSubject<Void, Never>()
    
    private var dataSource = [ReceipeData]()
    
    var count: Int { dataSource.count }
    
    subscript(index: Int) -> ReceipeData? {
        guard dataSource.indices.contains(index) else { return nil }
        return dataSource[index]
    }

    func add() {
        let data = ReceipeData(
            title: "In this Blog I shall be talking about adding Dynamically resizing UITableViewCells. There are a bunch of articles and videos on the internet but almost all of them revolve around the implementation using storyboards.",
            image: UIImage(named: "food")!,
            description: "In this Blog I shall be talking about adding Dynamically resizing UITableViewCells. There are a bunch of articles and videos on the internet"
        )
        dataSource.append(data)
        isDataUpdated.send(Void())
    }
}
