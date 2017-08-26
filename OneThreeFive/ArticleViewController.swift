//
//  ArticleViewController.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/13/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import UIKit

class ArticleViewController:  UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!

    @IBOutlet weak var loadingIndicator: LoadingIndicator!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    var articleCache: [Article] = []
    var currentIndex = 0
    override func viewDidLoad() {
        webView.delegate = self
        favoriteButton.isEnabled = false
        updateView()
    }
    
    // TODO: improve swipe implementation
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex + 1) % articleCache.count
            updateView()
        }
    }
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            currentIndex = (currentIndex - 1 + articleCache.count) % articleCache.count
            updateView()
        }
    }
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        if let urlString = articleCache[currentIndex].url,
            let link = NSURL(string: urlString)
        {
            let objectsToShare = [link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }

        let article = articleCache[currentIndex]
        if(!article.isViewed) {
            print("not loaded yet, bitch")
            return
        }
        if(article.isFavorited) {
            favoriteButton.image = #imageLiteral(resourceName: "star")
            ArticleService.unfavoriteArticle(article: article)
        } else {
            favoriteButton.image = #imageLiteral(resourceName: "star_filled")
            ArticleService.favoriteArticle(article: article)
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingIndicator.stopLoading()
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            return
        }
        self.articleCache[self.currentIndex].isViewed = true
        self.articleCache[self.currentIndex].readAt = Date() as NSDate
        CoreDataHelper.save()
    }
    
    func updateView() {
        if currentIndex >= articleCache.count {
            print("Error: current index \(currentIndex) out of bounds for article cache of size \(articleCache.count)")
            
        }
        let article = articleCache[currentIndex]
        updateNavBar(article: article)
        attemptLoadArticle(article: article)
    }
    
    func updateNavBar(article: Article) {
        
        if(article.isFavorited) {
            favoriteButton.image = #imageLiteral(resourceName: "star_filled")
        } else {
            favoriteButton.image = #imageLiteral(resourceName: "star")
        }
        favoriteButton.isEnabled = true

    }
    
    func attemptLoadArticle(article: Article) {
        self.loadingIndicator.startLoading(image: Constants.Settings.timeImage(Int(article.time)))
        if let url = URL(string: (article.url)!) {
            let urlRequest = URLRequest(url: url)
            self.webView.loadRequest(urlRequest)
        } else {
            print("Error: could not load article")
        }
        
    }
}
