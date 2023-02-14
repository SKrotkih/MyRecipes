//
//  RecipeItemView.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 13.02.2023.
//
import UIKit

typealias TabButtonClosure = () -> Void

class RecipeItemView: UIView {
    var onDelete: TabButtonClosure = {}
    var onShare: TabButtonClosure = {}
    var onFavorite: TabButtonClosure = {}
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBAction func onDeleteButtonPressed(_ sender: Any) {
        onDelete()
    }
    @IBAction func onShareButtonPressed(_ sender: Any) {
        onShare()
    }
    @IBAction func onFavoriteButtonPressed(_ sender: Any) {
        onFavorite()
    }
}
