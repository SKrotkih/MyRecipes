//
//  RecipesViewController.swift
//  MyRecipes
//
//  Created by Sergey Krotkih on 13.02.2023.
//
import UIKit

class RecipesViewController: UIViewController {
    @IBOutlet var RecipeItemView: RecipeItemView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.reloadData()
    }
}

extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let row = indexPath.row
        
        Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
        let cellView = self.RecipeItemView!

        cellView.titleLabel.text = "\(row + 1)\nIn this Blog I shall be talking about adding Dynamically resizing UITableViewCells. There are a bunch of articles and videos on the internet but almost all of them revolve around the implementation using storyboards."

        cellView.descriptionLabel.text = "\(row + 1)\nIn this Blog I shall be talking about adding Dynamically resizing UITableViewCells. There are a bunch of articles and videos on the internet but almost all of them revolve around the implementation using storyboards."

        cellView.imageView.image = UIImage(named: "food")
        
        cell.addSubview(cellView)

        var height: CGFloat = 0.0
        cellView.titleLabelHeight.constant = 100.0
        height += 100.0
        height += 5.0
        cellView.imageViewHeight.constant = 200.0
        height += 200.0
        height += 5.0
        cellView.descriptionLabelHeight.constant = 100.0
        height += 100.0
        height += 5.0
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            cellView.topAnchor.constraint(equalTo: cell.topAnchor),
            cellView.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            cellView.heightAnchor.constraint(equalToConstant: height)
        ])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}
