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

    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var articleCache: [Article] = []
    var currentIndex = 0
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLoad() {
        favoriteButton.isEnabled = false
        configureView()
    }
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex + 1) % articleCache.count
            configureView()
        }
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex - 1 + articleCache.count) % articleCache.count
            configureView()
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }
        print("button pressed")
        let article = articleCache[currentIndex]
        if(article.isFavorited) {
            print("isFavorited")
            favoriteButton.image = #imageLiteral(resourceName: "star")
            ArticleService.unfavoriteArticle(article: article)
        } else {
            print("is not Favorited")
            favoriteButton.image = #imageLiteral(resourceName: "star_filled")
            ArticleService.favoriteArticle(article: article)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
        //CoreDataHelper.persistentContainer.performBackgroundTask { context in
        self.articleCache[self.currentIndex].isViewed = true
        self.articleCache[self.currentIndex].readAt = Date() as NSDate
        CoreDataHelper.save()
    }
    
    func configureView() {
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }
        let article = articleCache[currentIndex]
        if(article.isFavorited) {
            favoriteButton.image = #imageLiteral(resourceName: "star_filled")
        } else {
            favoriteButton.image = #imageLiteral(resourceName: "star")
        }
        favoriteButton.isEnabled = true
        attemptLoadArticle(article: article)

    }
    
    func attemptLoadArticle(article: Article) {
        // TODO: enable swiping
        self.spinner.startAnimating()
        if let url = URL(string: (article.url)!) {
            let urlRequest = URLRequest(url: url)
            self.webView.loadRequest(urlRequest)
        } else {
            print("Error: could not load article")
        }
        
    }
}
