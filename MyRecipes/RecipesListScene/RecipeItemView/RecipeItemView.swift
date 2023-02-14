//
//  RecipeItemView.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 13.02.2023.
//
import UIKit

class RecipeItemView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    
    func configure(with cell: UITableViewCell, model: ReceipeData?, width: CGFloat) {
        guard let model else { return }
        titleLabel.text = model.title
        imageView.image = UIImage(named: model.imageID ?? "")
        descriptionLabel.text = model.description
        let h1 = model.title?.height(for: width, font: titleLabel.font) ?? 0
        let h2 = imageView.image?.height(for: width) ?? 0
        let h3 = model.description?.height(for: width, font: descriptionLabel.font) ?? 0
        titleLabelHeight.constant = h1
        imageViewHeight.constant = h2
        descriptionLabelHeight.constant = h3
        let height: CGFloat = h1 + h2 + h3 + 5.0 * 4
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            topAnchor.constraint(equalTo: cell.topAnchor),
            bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
