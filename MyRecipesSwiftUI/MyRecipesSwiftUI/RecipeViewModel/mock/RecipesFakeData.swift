//
//  RecipesFakeData.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 14.02.2023.
//
import Foundation

/// Data Layer:
/// Recipes mock data
class RecipesFakeData: RecipesListData {
    private let helper = CoreDataHelper()
    override func add() {
        helper.fetchFakeRecipes()
    }
    
    override func deleteRecipe(_ recipe: Recipe) {
        super.deleteRecipe(recipe)
    }

    override func markRecipeAsVavorite(_ recipe: Recipe) {
        super.markRecipeAsVavorite(recipe)
    }

    override func shareRecipe(_ recipe: Recipe) {
        super.shareRecipe(recipe)
    }
}
