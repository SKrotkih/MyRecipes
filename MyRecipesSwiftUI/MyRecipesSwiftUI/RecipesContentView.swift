//
//  RecipesContentView.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 21.02.2023.
//
import SwiftUI

struct RecipesContentView<ViewModel: RecipesListDataSource>: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @State var searchText = ""
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.id, ascending: true)],
        animation: .default)
    private var recipes: FetchedResults<RecipeEntity>
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List {
                    ForEach(recipes) { recipe in
                        NavigationLink(destination: RecipeDetailsView(viewModel: viewModel, entity: recipe)) {
                            let width = geometry.size.width - 30.0
                            RecipeRow(viewModel: viewModel, width: width, entity: recipe)
                                .frame(width: width, height: rowHeight(entity: recipe, width: width))
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listRowBackground(Color.black)
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recipe Name Search")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Spacer()
                            Text("My Recipes")
                                .bold()
                                .foregroundColor(.yellow)
                            Spacer()
                            Button("Add") {
                                addRecipe()
                            }
                            .padding(.trailing, 5.0)
                            .foregroundColor(.white)
                        }
                    }
                }
                .background(.black)
            }
        }
    }
}

extension RecipesContentView {
    private func rowHeight(entity: RecipeEntity, width: CGFloat) -> CGFloat {
        if let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
            let model = Recipe(managedObject: entity)
            var height = model.title.height(for: width, font: view.titleLabel.font)
            height += UIImage(named: model.imageID)?.height(for: width) ?? 0.0
            height += model.text.height(for: width, font: view.descriptionLabel.font)
            return height + 5.0 * 3 + 30.0  // see RecipeItemView.xib file to find out the constants
        }
        return 0.0
    }
    
    private func addRecipe() {
        CoreDataHelper().fetchFakeRecipes()
    }
}

/// Recipe Row View is in the RecipeItemView.xib file presented
struct RecipeRow<ViewModel: RecipesListDataSource>: UIViewRepresentable {
    typealias UIViewType = RecipeItemView

    let viewModel: ViewModel
    let width: CGFloat
    @ObservedObject var entity: RecipeEntity
    
    /// UIViewRepresentable protocol implementation method
    /// Loads nib file with the Recipe Row layout and fill in Recipe data entity
    /// - Parameter context: sent by UIViewRepresentable
    /// - Returns: RecipeItemView by UIView inherited. Ready to show In the SwiftUI View stack
    func makeUIView(context: Context) -> RecipeItemView {
       if let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
           updateUIView(view, context: context)
           return view
        }
        return RecipeItemView()
    }
    
    /// UIViewRepresentable protocol implementation method. Called after updating RecipeEntity
    /// - Parameters:
    ///   - view: UIView with Recipe Item view layout
    /// - Parameter context: sent by UIViewRepresentable
    func updateUIView(_ view: RecipeItemView, context: Context) {
        let model = Recipe(managedObject: entity)
        view.titleLabel.text = model.title
        view.imageView.image = UIImage(named: model.imageID)
        view.descriptionLabel.text = model.text
        view.titleLabelHeight.constant = model.title.height(for: width, font: view.titleLabel.font)
        view.imageViewHeight.constant = view.imageView.image?.height(for: width) ?? 0
        view.descriptionLabelHeight.constant = model.text.height(for: width, font: view.descriptionLabel.font)
        let image = UIImage(systemName: model.favorite ? "bookmark": "bookmark.fill")
        view.favoriteButton.setImage(image, for: .normal)
        view.onDelete = { viewModel.deleteRecipe(model) }
        view.onShare = { viewModel.shareRecipe(model) }
        view.onFavorite = { viewModel.markRecipeAsVavorite(model) }
    }
}

struct RecipesContentView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesContentView(viewModel: RecipesFakeData())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
