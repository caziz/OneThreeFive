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
    
    var favoritedArticles: [FavoritedArticle] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadFavoritedArticles()
    }
    
    func loadFavoritedArticles() {
        self.favoritedArticles = CoreDataHelper.getFavoritedArticles()
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
        if let url = favoritedArticles[indexPath.row].url {
            cell.label.text = url
            return cell
        }
        cell.label.text = "cant find url"
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritedArticles.count
    }
}
