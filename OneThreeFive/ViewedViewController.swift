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
    var filteredArticles: [Article] = []
    
    @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var animatedSearchBar: AnimatedSearchBar!
    @IBOutlet weak var viewedArticlesTableView: UITableView!
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        animatedSearchBar.toggle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animatedSearchBar.initSearchbar(view: view, constraint: searchBarTopConstraint, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewedArticles = ArticleService.getSaved(context: CoreDataHelper.managedContext)
            .filter{$0.isFavorited}
            .sorted{($0.readAt! as Date) > ($1.readAt! as Date)}
        displayWithFilter(text: animatedSearchBar.text ?? "")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let articleViewController = segue.destination as? ArticleViewController,
            let indexPath = viewedArticlesTableView.indexPathForSelectedRow {
            articleViewController.currentIndex = indexPath.row
            articleViewController.articleCache = filteredArticles
        }
    }
}

extension ViewedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        animatedSearchBar.dismiss()
    }

}

extension ViewedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewedArticlesTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.viewedArticleCell, for: indexPath) as! ViewedArticleCell
        let article = filteredArticles[indexPath.row]
        cell.label.text = article.title!
        cell.icon.image = ImageService.loadImage(path: article.source!.id!)
        if cell.icon.image == nil {
            cell.icon.image = #imageLiteral(resourceName: "source_default")
        }

        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
}

extension ViewedViewController: AnimatedSearchBarDelegate {
    func displayWithFilter(text: String) {
        if text == "" {
            filteredArticles = viewedArticles
        } else {
            filteredArticles = viewedArticles.filter {
                $0.title!.capitalized.contains(text.capitalized) || $0.source!.name!.capitalized.contains(text.capitalized)
            }
        }
        viewedArticlesTableView.reloadData()
    }
}
