//
//  ViewedArticle.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/20/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData

extension Article {
    static func create() -> Article {
        return Article(context: CoreDataHelper.managedContext)
    }
    
    static func getAll() -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
