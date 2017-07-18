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
    var articleLengthInMinutes: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(articleLengthInMinutes ?? 0)
        print(attemptLoadWebPage())
        
        
    }
    
    
    
    func attemptLoadWebPage() -> Bool {
        guard
            let articleLength = articleLengthInMinutes,
            let length = Constants.ArticleLengthInMinutes(rawValue: articleLength)
             else {
            return false
        }
        let sources = CoreDataHelper.getEnabledNewsSources().map{$0.id!}
        
        spinner.startAnimating()
        FireBaseService.getURLs(option: length, sources: sources) { dict in
            var allArticles = dict
            let keys = Array(dict.keys)
            let viewedArticles = CoreDataHelper.getViewedArticles().map{$0.url!}
            while !dict.isEmpty {
                let randIndex = Int(arc4random_uniform(UInt32(dict.count)))
                let articles = dict[keys[randIndex]]!
                allArticles[keys[randIndex]] = nil
                for article in articles{
                    if !viewedArticles.contains(article) {
                        let viewedArticle = CoreDataHelper.createViewedArticle()
                        viewedArticle.url = article
                        CoreDataHelper.save()
                        DispatchQueue.main.async {
                            self.webView.loadRequest(URLRequest(url: URL(string:article)!))
                            self.spinner.stopAnimating()
                        }
                        return
                    }
                }
            }
            
        }
        return true
    }
    
}

extension ArticleViewController: UIWebViewDelegate {
    
}
