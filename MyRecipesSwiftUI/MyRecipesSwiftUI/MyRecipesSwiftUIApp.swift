//
//  MyRecipesSwiftUIApp.swift
//  MyRecipesSwiftUI
//
//  Created by Serhii Krotkykh on 21.02.2023.
//

import SwiftUI

@main
struct MyRecipesSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            RecipesContentView()
                .environmentObject(RecipesFakeData())
        }
    }
}
