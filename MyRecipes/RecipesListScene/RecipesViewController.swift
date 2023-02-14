//
//  RecipesViewController.swift
//  MyRecipes
//
//  Created by Serhii Krotkykh on 13.02.2023.
//
import UIKit
import Combine

class RecipesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var itemView: RecipeItemView!
    var viewModel: RecipesListDataSource = RecipesFakeData()
    private var disposableBag = Set<AnyCancellable>()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        subscribeOnInputData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        viewModel.add()
    }
    
    private func subscribeOnInputData() {
        viewModel.isDataUpdated
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &disposableBag)
    }
    
    private func configureView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - TableView delegate and data source protocols
extension RecipesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        Bundle.main.loadNibNamed("RecipeItemView", owner: self, options: nil)
        cell.addSubview(itemView!)
        itemView!.configure(with: cell, model: viewModel[indexPath.row], width: tableView.frame.width)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
    }
}
