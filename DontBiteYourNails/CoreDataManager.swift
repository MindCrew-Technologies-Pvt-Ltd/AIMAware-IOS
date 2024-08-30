//
//  CoreDataManager.swift
//  DontBiteYourNails
//
//  Created by Sune Kristian Jakobsen on 30/07/2023.
//  Copyright © 2023 Sune Kristian Jakobsen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager : ObservableObject{
    static let shared = CoreDataManager()

    
    // The persistent container for Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        return container
    }()

    // Set up the persistent container and load the persistent stores
    func setupPersistentContainer() {
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // Provide the view context (main queue context) for SwiftUI environment object
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    
   // private init() {}

//    func fetchAlerts(persistentContainer : NSPersistentContainer) -> [Alert] {
  //      let context = persistentContainer.viewContext
    //    let request: NSFetchRequest<Alert> = Alert.fetchRequest()
//
  //      do {
    //        let elements = try context.fetch(request)
      //      return elements
        //} catch {
          //  print("Error fetching alerts: \(error.localizedDescription)")
            //return []
//        }
  //  }
    
    
    func getNumberOfAlerts() -> Int{
        let fetchRequest: NSFetchRequest<Alert> = Alert.fetchRequest()

        do {
               let context = CoreDataManager.shared.persistentContainer.viewContext
               let totalAlertCount = try context.count(for: fetchRequest)
               return totalAlertCount
           } catch {
               // Handle any errors that may occur during the fetch
               print("Error fetching total alert count: \(error)")
               return 0
           }
    }    
    
    func getNumberOfUndenidedAlerts() -> Int{
        let fetchRequest: NSFetchRequest<Alert> = Alert.fetchRequest()

        let predicate = NSPredicate(format: "secondary == %@ AND status != %@", NSNumber(value: false), SharedConstants.denied)
        fetchRequest.predicate = predicate
        
        do {
               let context = CoreDataManager.shared.persistentContainer.viewContext
               let totalAlertCount = try context.count(for: fetchRequest)
               return totalAlertCount
           } catch {
               // Handle any errors that may occur during the fetch
               print("Error fetching total alert count: \(error)")
               return 0
           }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.performAndWait {
                    // Perform save operation within this block
                    if context.hasChanges {
                        try context.save()
                    }
                }
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
