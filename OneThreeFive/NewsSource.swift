//
//  NewsSource.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/20/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData

extension NewsSource {
    static func create() -> NewsSource {
        return NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.newsSource, into: CoreDataHelper.managedContext) as! NewsSource
    }
    
    static func getAll() -> [NewsSource] {
        let fetchRequest = NSFetchRequest<NewsSource>(entityName: Constants.Entity.newsSource)
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
