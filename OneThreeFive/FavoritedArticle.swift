//
//  FavoritedArticle.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/20/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData

extension FavoritedArticle {
    static func create() -> FavoritedArticle {
        return NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.favoritedArticle, into: CoreDataHelper.managedContext) as! FavoritedArticle
    }
    
    static func getAll() -> [FavoritedArticle] {
        let fetchRequest = NSFetchRequest<FavoritedArticle>(entityName: Constants.Entity.favoritedArticle)
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
