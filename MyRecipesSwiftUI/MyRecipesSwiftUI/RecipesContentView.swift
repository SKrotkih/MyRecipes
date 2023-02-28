//
//  RecipesContentView.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 21.02.2023.
//
import SwiftUI

struct RecipesContentView: View {
    @EnvironmentObject var viewModel: RecipesFakeData   // protocol must be
    var body: some View {
        GeometryReader { geometry in
            VStack {
                NavigationBar()
                List {
                    ForEach(0..<viewModel.count, id: \.self) { index in
                        let width = geometry.size.width - 30.0
                        RecipeRow(index: index, width: width)
                            .frame(width: width, height: rowHeight(index: index, width: width))
                            .background(.black)
                    }
                 }
                .background(.black)
                .scrollContentBackground(.hidden)
            }
            .background(.black)
        }
    }
    
    private func rowHeight(index: Int, width: CGFloat) -> CGFloat {
        if let model = viewModel[index],
           let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
            var height = model.title?.height(for: width, font: view.titleLabel.font) ?? 0
            height += model.image?.height(for: width) ?? 0
            height += model.description?.height(for: width, font: view.descriptionLabel.font) ?? 0
            return height + 5.0 * 3  // see RecipeItemView.xib layout
        }
        return 0.0
    }

    struct NavigationBar: View {
        @EnvironmentObject var viewModel: RecipesFakeData
        var body: some View {
            HStack {
                Spacer()
                Text("My Recipes")
                    .foregroundColor(.white)
                Spacer()
                Button {
                    viewModel.add()
                } label: {
                    Text("Add")
                        .foregroundColor(.white)
                        .padding(.trailing, 15.0)
                }
            }
        }
    }
}

struct RecipeRow: UIViewRepresentable {
    @EnvironmentObject var viewModel: RecipesFakeData
    typealias UIViewType = RecipeItemView
    private let index: Int
    private let width: CGFloat
    
    init(index: Int, width: CGFloat) {
        self.index = index
        self.width = width
    }

    func makeUIView(context: Context) -> RecipeItemView {
        if let model = viewModel[index],
           let view = Bundle.main.loadNibNamed("RecipeItemView", owner: nil, options: nil)?.first as? RecipeItemView {
            view.titleLabel.text = model.title ?? ""
            view.imageView.image = model.image
            view.descriptionLabel.text = model.description ?? ""
            view.titleLabelHeight.constant = model.title?.height(for: width, font: view.titleLabel.font) ?? 0
            view.imageViewHeight.constant = model.image?.height(for: width) ?? 0
            view.descriptionLabelHeight.constant = model.description?.height(for: width, font: view.descriptionLabel.font) ?? 0
            return view
        }
        return RecipeItemView()
    }
    
    func updateUIView(_ view: RecipeItemView, context: Context) { }
}
