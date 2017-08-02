//
//  ViewedViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/31/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ViewedViewController: UIViewController {
    var viewedArticles: [Article] = []
    
    @IBOutlet weak var viewedArticlesTableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadViewedArticles()
    }
    
    func loadViewedArticles() {
        viewedArticles = ArticleService.getSaved(context: CoreDataHelper.managedContext)
            .filter{$0.isViewed}.sorted{($0.readAt! as Date) > ($1.readAt! as Date)}
        self.viewedArticlesTableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let cell = sender as? UITableViewCell {
            articleViewController.currentIndex = viewedArticlesTableView.indexPath(for: cell)!.row
            articleViewController.articleCache = viewedArticles
        }
    }
}

extension ViewedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ViewedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewedArticlesTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.viewedArticleCell, for: indexPath) as! ViewedArticleCell
        let article = viewedArticles[indexPath.row]
        cell.label.text = article.title!
        let image = ImageService.loadImage(path: article.source!.id!)
        if image != nil {
            cell.icon.image = image
        } else {
            cell.icon.image = #imageLiteral(resourceName: "news")
        }

        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewedArticles.count
    }
}
