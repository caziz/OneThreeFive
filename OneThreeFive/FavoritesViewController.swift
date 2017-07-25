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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavoritedArticles()
    }
    
    func loadFavoritedArticles() {
        favoritedArticles = ArticleService.getSaved().filter{$0.isFavorited}
        self.favoritesTableView.reloadData()
    }
}



extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.favoritedArticleCell, for: indexPath) as! FavoritedArticleCell
        cell.label.text = favoritedArticles[indexPath.row].title!
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedArticles.count
    }
}
