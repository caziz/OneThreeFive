//
//  FavoritesViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/17/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoritesTableView: UITableView!
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        animatedSearchBar.toggle()
    }
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var animatedSearchBar: AnimatedSearchBar!
    var favoritedArticles: [Article] = []
    var filteredArticles: [Article] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedSearchBar.initSearchbar(view: view, constraint: searchBarTopConstraint, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadFilteredTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let indexPath = favoritesTableView.indexPathForSelectedRow {
            articleViewController.currentIndex = indexPath.row
            articleViewController.articleCache = filteredArticles
        }
    }
    
    func reloadFilteredTableView() {
        favoritedArticles = ArticleService.getSaved(context: CoreDataHelper.managedContext)
            .filter{$0.isFavorited}
            .sorted{($0.readAt! as Date) > ($1.readAt! as Date)}
        displayWithFilter(text: animatedSearchBar.text ?? "")
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animatedSearchBar.dismiss()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Unfavorite"
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let unfavorite = UITableViewRowAction(style: .default, title: " Unfavorite ") { action, index in
            ArticleService.unfavoriteArticle(article: self.filteredArticles[index.row])
            self.reloadFilteredTableView()
        }
        unfavorite.backgroundColor = Constants.UI.mainColor
        return [unfavorite]
    }

}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.favoritedArticleCell, for: indexPath) as! FavoritedArticleCell
        let article = filteredArticles[indexPath.row];
        cell.label.text = article.title!
        if let imagePath = article.uid {
            let path = "\(imagePath)"
            cell.icon.image = ImageService.loadImage(path: path)
            if cell.icon.image == nil {
                switch article.time {
                case 1:
                    cell.icon.image = #imageLiteral(resourceName: "one_unlabeled")
                case 3:
                    cell.icon.image = #imageLiteral(resourceName: "three_unlabeled")
                default:
                    cell.icon.image = #imageLiteral(resourceName: "five_unlabeled")
                }
                cell.icon.layer.cornerRadius = 3
                cell.icon.clipsToBounds = true
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
}

extension FavoritesViewController: AnimatedSearchBarDelegate {
    func displayWithFilter(text: String) {
        if text == "" {
            filteredArticles = favoritedArticles
        } else {
            filteredArticles = favoritedArticles.filter {
                $0.title!.capitalized.contains(text.capitalized) || $0.source!.name!.capitalized.contains(text.capitalized)
            }
        }
        
        favoritesTableView.reloadData()
    }
}
