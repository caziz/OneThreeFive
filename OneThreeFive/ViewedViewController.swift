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
            .filter{$0.isViewed}.sorted{$0.date! < $1.date!}
        self.viewedArticlesTableView.reloadData()
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
        cell.label.text = viewedArticles[indexPath.row].title!
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewedArticles.count
    }
}
