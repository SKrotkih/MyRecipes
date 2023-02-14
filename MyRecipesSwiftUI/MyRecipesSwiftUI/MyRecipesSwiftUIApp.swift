//
//  MyRecipesSwiftUIApp.swift
//  MyRecipesSwiftUI
//
//  Created by Serhii Krotkykh on 21.02.2023.
//

import SwiftUI

@main
struct MyRecipesSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RecipesContentView(viewModel: RecipesFakeData())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
