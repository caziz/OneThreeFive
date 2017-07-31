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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        attemptLoadWebPage()
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex + 1) % articleCache.count
            attemptLoadWebPage()
        }
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex - 1 + articleCache.count) % articleCache.count
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
        //CoreDataHelper.persistentContainer.performBackgroundTask { context in
        self.articleCache[self.currentIndex].isViewed = true
        self.articleCache[self.currentIndex].readTime = Date() as NSDate
        CoreDataHelper.save()
    }
        
    func attemptLoadWebPage() {
        // TODO: enable swiping
        self.spinner.startAnimating()
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }
        if let url = URL(string: (articleCache[currentIndex].url)!) {
            let urlRequest = URLRequest(url: url)
            self.webView.loadRequest(urlRequest)
        } else {
            print("Error: could not load article/article cache")
        }
        
    }
}
