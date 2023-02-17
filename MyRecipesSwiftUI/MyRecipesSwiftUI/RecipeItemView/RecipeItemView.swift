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
}
