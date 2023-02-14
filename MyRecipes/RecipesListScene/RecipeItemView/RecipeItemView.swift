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
    // Constants Constraints
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    
    func configure(with cell: UITableViewCell, model: ReceipeData?, width: CGFloat) {
        func textHeight(of text: String?, width: CGFloat, font: UIFont) -> CGFloat {
            if let text {
                return text.heightWithConstrainedWidth(width: width, font: font)
            } else {
                return 0.0
            }
        }
        func imageHeight(of image: UIImage?, width: CGFloat) -> CGFloat {
            guard let image else { return 0.0 }
            let size = image.size
            let k = width / size.width
            return size.height * k
        }
        guard let model else { return }
        
        titleLabel.text = model.title
        imageView.image = model.image
        descriptionLabel.text = model.description

        var height: CGFloat = 0.0
        let h1 = textHeight(of: model.title, width: width, font: titleLabel.font)
        titleLabelHeight.constant = h1
        height += h1; height += 5.0
        let h2 = imageHeight(of: model.image, width: width)
        imageViewHeight.constant = h2
        height += h2; height += 5.0
        let h3 = textHeight(of: model.description, width: width, font: descriptionLabel.font)
        descriptionLabelHeight.constant = h3
        height += h3; height += 5.0
        
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

extension String {
    func heightWithConstrainedWidth(width: CGFloat,
                                    font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
}
