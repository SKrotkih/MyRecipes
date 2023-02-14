//
//  Recipe.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import Foundation

/// The app Model
///
struct RecipesContainer: Codable {
    let title: String?
    let recipes: [Recipe]?
}

struct Recipe: Codable {
    var id: String
    var title: String
    var imageID: String
    var text: String
    var favorite: Bool
}

extension Recipe: CoreDataPersistable {
    init() {
        id = UUID().uuidString
        title = ""
        imageID = ""
        text = ""
        favorite = false
    }

    var keyMap: [PartialKeyPath<Recipe> : String] {
        [ \.title: "title",
          \.imageID: "imageID",
          \.text: "text",
          \.id: "id",
          \.favorite: "favorite"
        ]
    }
    typealias ManagedType = RecipeEntity
}
