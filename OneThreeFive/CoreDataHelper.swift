//
//  CoreDataHelper.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData
import UIKit

struct CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func getEnabledNewsSource() -> EnabledNewsSource {
        let enabledNewsSource = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.enabledNewsSource, into: managedContext) as! EnabledNewsSource
        return enabledNewsSource
    }
    
    static func saveEnabledNewsSource() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
    
    static func delete(enabledNewsSource: EnabledNewsSource) {
        managedContext.delete(enabledNewsSource)
    }
    
    static func retrieveEnabledNewsSources() -> [EnabledNewsSource] {
        let fetchRequest = NSFetchRequest<EnabledNewsSource>(entityName: Constants.Entity.enabledNewsSource)
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }
}
