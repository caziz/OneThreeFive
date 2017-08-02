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
    
    var favoritedArticles: [Article] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO
        //self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFavoritedArticles()
    }
    
    func loadFavoritedArticles() {
        favoritedArticles = ArticleService.getSaved(context: CoreDataHelper.managedContext)
            .filter{$0.isFavorited}
            .sorted{($0.readAt! as Date) > ($1.readAt! as Date)}
        self.favoritesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let cell = sender as? UITableViewCell {
            articleViewController.currentIndex = favoritesTableView.indexPath(for: cell)!.row
            articleViewController.articleCache = favoritedArticles
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.favoritedArticleCell, for: indexPath) as! FavoritedArticleCell
        let article = favoritedArticles[indexPath.row];
        cell.label.text = article.title!
        if let imagePath = article.uid {
            let path = "\(imagePath)"
            cell.icon.image = ImageService.loadImage(path: path)
            if cell.icon.image == nil {
                cell.icon.image = #imageLiteral(resourceName: "news")
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedArticles.count
    }
}
