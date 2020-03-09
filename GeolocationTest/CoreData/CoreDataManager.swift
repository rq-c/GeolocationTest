//
//  CoreDataManager.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

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
    
    func createRoute(name : String, distance : Double, time : Double, locations: [LocationModel], completion: @escaping() -> Void) {
        let context = container.viewContext
        
        let route = Route(context: context)
        route.id = self.fetchTotalRoutes()
        route.name = name
        route.distance = distance
        route.time = time
        route.date = Date()
        
        if !locations.isEmpty{
            for item in locations{
                let location = Location(context: context)
                location.latitude = item.latitude
                location.longitude = item.longitude
                route.addToLocations(location)
            }
        }

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
    
    func fetchTotalRoutes() -> Int16 {
        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return Int16(result.count)
        } catch {
            print("Error getting routes \(error)")
        }
        return 0
    }
    
    func deleteRoute(){
        
    }
}
