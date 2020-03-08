//
//  CoreDataManager.swift
//  GeolocationTest
//
//  Created by Emmauel Galindo on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    private let container : NSPersistentContainer!
    
    init() {
        container = NSPersistentContainer(name: "GeoModel")
        setupDatabase()
    }
    
    private func setupDatabase() {
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready.")
        }
    }
    
    func createRoute(name : String, distance : Double, time : Double, completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let route = Route(context: context)
        route.name = name
        route.distance = distance
        route.time = time
        route.date = Date()

        do {
            try context.save()
            print("Route \(name) saved")
            completion()
        } catch {
            print("Error saving route  — \(error)")
        }
    }
    
    func fetchRoutes() -> [Route] {
        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("Error getting routes \(error)")
        }
        return []
    }
    
    func deleteRoute(){
        
    }
}
