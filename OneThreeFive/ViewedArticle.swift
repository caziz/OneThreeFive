//
//  ViewedArticle.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/20/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData

extension ViewedArticle {
    static func create() -> ViewedArticle {
        return NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.viewedArticle, into: CoreDataHelper.managedContext) as! ViewedArticle
    }
    
    static func getAll() -> [ViewedArticle] {
        let fetchRequest = NSFetchRequest<ViewedArticle>(entityName: Constants.Entity.viewedArticle)
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
