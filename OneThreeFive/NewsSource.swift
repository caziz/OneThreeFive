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
        return NewsSource(context: CoreDataHelper.managedContext)
    }
    
    static func getAll() -> [NewsSource] {
        let fetchRequest: NSFetchRequest<NewsSource> = NewsSource.fetchRequest()
        do {
            let results = try CoreDataHelper.managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
