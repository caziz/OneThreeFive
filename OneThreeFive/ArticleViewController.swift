//
//  ArticleViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ArticleViewController:  UIViewController {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!

    var articleCache: [Article] = []
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        attemptLoadWebPage()
        
        
    }
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended &&
            currentIndex != articleCache.count - 1 {
            currentIndex += 1
            attemptLoadWebPage()
        }
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended && currentIndex != 0{
            currentIndex -= 1
            attemptLoadWebPage()
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        ArticleService.favoriteArticle(article: articleCache[currentIndex])
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if webView.isLoading {
            return
        }
        self.spinner.stopAnimating()
        
        CoreDataHelper.persistentContainer.performBackgroundTask { context in
            do {
                self.articleCache[self.currentIndex].isViewed = true
                try context.save()
            } catch let error as NSError {
                print("Error: could not save article  as viewed, \(error)")
            }
        }
        
        print("TODO: save article as viewed")
    }
        
    func attemptLoadWebPage() {
        let url = URL(string: articleCache[currentIndex].url!)
        let urlRequest = URLRequest(url: url!)
        self.webView.loadRequest(urlRequest)
    }
}
