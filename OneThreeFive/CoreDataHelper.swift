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
    
    static func delete(object: NSManagedObject) {
        managedContext.delete(object)
    }
    
    static func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }
}
