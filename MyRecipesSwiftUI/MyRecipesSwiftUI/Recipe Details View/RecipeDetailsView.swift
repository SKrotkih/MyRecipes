//
//  RecipeDetailsView.swift
//  MyRecipesSwiftUI
//
//  Created by Sergey Krotkih on 28.03.2023.
//

import SwiftUI

struct RecipeDetailsView<ViewModel: RecipesListDataSource>: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var entity: RecipeEntity
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            let model = Recipe(managedObject: entity)
            VStack {
                Text(model.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Image(model.imageID)
                    .padding(.top, 5.0)
                    .tint(.white)
                Text(model.text)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 5.0)
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Text("My Recipes")
                            .bold()
                            .foregroundColor(.yellow)
                        Spacer()
                        Button {
                            viewModel.markRecipeAsVavorite(model)
                        } label: {
                            Image(systemName: model.favorite ? "bookmark": "bookmark.fill")
                        }
                        .padding(.top, 5.0)
                    }
                }
            }
            .background(.black)
        }
        .background(.black)
    }
}
