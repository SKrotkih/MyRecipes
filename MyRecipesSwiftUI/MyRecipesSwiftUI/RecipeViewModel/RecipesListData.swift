//
//  RecipesListData.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import UIKit
import Combine

/// Recipes list data source protocol
protocol RecipesListDataSource: ObservableObject, AnyObject {
    func add()
    func deleteRecipe(_ recipe: Recipe)
    func markRecipeAsVavorite(_ recipe: Recipe)
    func shareRecipe(_ recipe: Recipe)
}

/// Recipes Data Source Base Class
/// Sub class has to generate dataSource and call super.add() method
class RecipesListData: RecipesListDataSource {
    private let helper = CoreDataHelper()

    @MainActor
    func add() {
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        helper.deleteRecipe(recipe)
    }

    func markRecipeAsVavorite(_ recipe: Recipe) {
        helper.markRecipeAsVavorite(recipe)
    }

    func shareRecipe(_ recipe: Recipe) {
        print("SHARE \(recipe.id)")
    }
}
