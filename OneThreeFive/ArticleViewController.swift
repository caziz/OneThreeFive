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
    var url: String?
    var articleLengthInMinutes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startAnimating()
        print(articleLengthInMinutes ?? 0)
        attemptLoadWebPage()
        
        
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        print("article favorited")
        if let urlString = url {
            let favoritedArticle = CoreDataHelper.createFavoritedArticle()
            favoritedArticle.url = urlString
            CoreDataHelper.save()

        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        //self.spinner.startAnimating()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    
    
    func attemptLoadWebPage() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let articleLength = self.articleLengthInMinutes,
                let length = Constants.ArticleLengthInMinutes(rawValue: articleLength)
                else {
                    return
            }
            let sources = CoreDataHelper.getEnabledNewsSources().map{$0.id!}
            FireBaseService.getURLs(option: length, sources: sources) { dict in
                var allArticles = dict
                let keys = Array(dict.keys)
                let viewedArticles = CoreDataHelper.getViewedArticles().map{$0.url!}
                while !allArticles.isEmpty {
                    let randIndex = Int(arc4random_uniform(UInt32(dict.count)))
                    let articles = dict[keys[randIndex]]!
                    print("searching \(keys[randIndex])\n")
                    allArticles[keys[randIndex]] = nil
                    for article in articles{
                        if !viewedArticles.contains(article) {
                            print("found unviewed article: \(article)\n")
                            let viewedArticle = CoreDataHelper.createViewedArticle()
                            viewedArticle.url = article
                            CoreDataHelper.save()
                            DispatchQueue.main.async { [weak self] in
                                self?.webView.loadRequest(URLRequest(url: URL(string:article)!))
                                self?.url = article
                            }
                            return
                        }
                        print("found article was previously viewed: \(article)\n")
                    }
                }
                
                print("you've already read all \(allArticles.count) articles!")
            }
        }
    }
}

extension ArticleViewController: UIWebViewDelegate {
    
}
