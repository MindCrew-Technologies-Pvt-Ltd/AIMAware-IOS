//
//  ActiveDateRepo.swift
//  AImAware
//
//  Created by Sune on 18/01/2024.
//  Copyright © 2024 Sune Kristian Jakobsen. All rights reserved.
//


import Foundation
import CoreData

class ActiveDateRepo {
    
    static var shared = ActiveDateRepo()
    
    var coreDataManager = CoreDataManager.shared
    
    
    public func fetchOrCreateActiveDate(date: Date, persistentContainer : NSPersistentContainer) -> ActiveDate {
        let request: NSFetchRequest<ActiveDate> = ActiveDate.fetchRequest()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        
        do {
            let results = try coreDataManager.viewContext.fetch(request)
            if let existingActiveDate = results.first {
                print("Fetched existing date")
                // If an ActiveDate entity with the given date is found, return it.
                return existingActiveDate
            } else {
                print("Creating new date")
                // If no ActiveDate entity is found, create a new one with the provided date.
                let newActiveDate = ActiveDate(context: coreDataManager.viewContext)
                newActiveDate.date = date
                
                /*try coreDataManager.viewContext.performAndWait {
                    // Perform save operation within this block
                    if coreDataManager.viewContext.hasChanges {
                        // Save the context to persist the new ActiveDate entity.
                        try coreDataManager.viewContext.save()
                        NotificationCenter.default.post(name: .activeDateUpdated, object: nil)
                    }
                }*/
                NotificationCenter.default.post(name: .activeDateUpdated, object: nil)
                return newActiveDate
            }
        } catch {
            // Handle fetch or save errors here...
            fatalError("Error fetching or creating ActiveDate entity: \(error)")
        }
    }
    
    public func hasSessionToday() -> Bool {
        let request: NSFetchRequest<ActiveDate> = ActiveDate.fetchRequest()
        let today = Calendar.current.startOfDay(for: Date())
        request.predicate = NSPredicate(format: "date == %@", today as NSDate)
        
        do {
            let results = try coreDataManager.viewContext.fetch(request)
            return results.first != nil
        } catch {
            fatalError("Error deciding if there is an activeDate today: \(error)")
        }
    }
    
    public func getDateWithoutTime(dateWithTime: Date) -> Date{
        let calendar = Calendar.current
        guard let truncatedDate = calendar.date(from: calendar.dateComponents([.day, .month, .year], from: dateWithTime)) else {
            fatalError("Unable to get start date from date")
        }
        return truncatedDate
    }
    
    
    
    public func getTotalDays() -> Int {
        return getAllActiveDays().count
    }
    
    public func getAllActiveDays() -> [ActiveDate] {
        let request: NSFetchRequest<ActiveDate> = ActiveDate.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(ActiveDate.date), ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            return try coreDataManager.viewContext.fetch(request)
        } catch {
            // Handle fetch or save errors here...
            print("Error fetching activeDates")
            return []
        }
    }
    
    public func getCurrentStreak() -> Int {
        let dateList = getAllActiveDays().compactMap { $0.date }
        return calculateCurrentStreak(dates: dateList)
    }
    
    fileprivate func calculateCurrentStreak(dates: [Date]) -> Int {
        // Sort dates in descending order
        let sortedDates = dates.map { Calendar.current.startOfDay(for: $0) }
                               .sorted(by: { $0 > $1 })
        let today = Calendar.current.startOfDay(for: Date())
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        guard let firstDate = sortedDates.first, firstDate >= yesterday else {
            return 0
        }
        
        var currentStreak = 0
        var lastDate: Date?

        for date in sortedDates {
            if let last = lastDate {
                if Calendar.current.isDate(date, inSameDayAs: last) {
                    // Skip if the date is the same as last (to handle duplicates)
                    continue
                } else if Calendar.current.isDate(date, equalTo: Calendar.current.date(byAdding: .day, value: -1, to: last)!, toGranularity: .day) {
                    // If the date is consecutive (the day before), increment the streak
                    currentStreak += 1
                } else {
                    // If the date is not consecutive, break the loop
                    break
                }
            } else {
                // Start the streak
                currentStreak = 1
            }

            lastDate = date
        }

        return currentStreak
    }

    
}
