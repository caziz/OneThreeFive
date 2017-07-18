//
//  CoreDataHelper.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData
import UIKit


// abid made me:

struct CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func createEnabledNewsSource() -> EnabledNewsSource {
        let enabledNewsSource = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.enabledNewsSource, into: managedContext) as! EnabledNewsSource
        return enabledNewsSource
    }
    
    static func createViewedArticle() -> ViewedArticle {
        let viewedArticle = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.viewedArticle, into: managedContext) as! ViewedArticle
        return viewedArticle
    }
    
    static func createFavoritedArticle() -> FavoritedArticle {
        let favoritedArticle = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.favoritedArticle, into: managedContext) as! FavoritedArticle
        return favoritedArticle
    }
    
    static func deleteEnabledNewsSource(enabledNewsSource: EnabledNewsSource) {
        managedContext.delete(enabledNewsSource)
    }
    
    static func deleteViewedArticle(viewedArticle: ViewedArticle) {
        managedContext.delete(viewedArticle)
    }
    
    static func deleteFavoritedArticle(favoritedArticle: FavoritedArticle) {
        managedContext.delete(favoritedArticle)
    }
    
    static func getEnabledNewsSources() -> [EnabledNewsSource] {
        let fetchRequest = NSFetchRequest<EnabledNewsSource>(entityName: Constants.Entity.enabledNewsSource)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func getViewedArticles() -> [ViewedArticle] {
        let fetchRequest = NSFetchRequest<ViewedArticle>(entityName: Constants.Entity.viewedArticle)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func getFavoritedArticle() -> [FavoritedArticle] {
        let fetchRequest = NSFetchRequest<FavoritedArticle>(entityName: Constants.Entity.favoritedArticle)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
    
    static func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
}
