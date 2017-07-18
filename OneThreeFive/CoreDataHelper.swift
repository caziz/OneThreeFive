//
//  CoreDataHelper.swift
//  OneThreeFive
//
//  Created by Christopher Aziz on 7/14/17.
//  Copyright © 2017 Christopher Aziz. All rights reserved.
//

import CoreData
import UIKit


// todo add entity enum param

struct CoreDataHelper {
    struct NewsSource {
        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
        static let persistentContainer = appDelegate.persistentContainer
        static let managedContext = persistentContainer.viewContext
        
        static func create() -> EnabledNewsSource {
            let enabledNewsSource = NSEntityDescription.insertNewObject(forEntityName: Constants.Entity.enabledNewsSource, into: managedContext) as! EnabledNewsSource
            return enabledNewsSource
        }
        
        static func save() {
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save \(error)")
            }
        }
        
        static func delete(enabledNewsSource: EnabledNewsSource) {
            managedContext.delete(enabledNewsSource)
        }
        
        static func retrieve() -> [EnabledNewsSource] {
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
}
