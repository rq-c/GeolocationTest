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
    
    private func saveContext(){
        let context = container.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context  — \(error)")
        }
    }
    
    func createRoute(name : String, distance : Double, time : Int16, locations: [LocationModel], completion: @escaping(Route) -> Void) {
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
        
        saveContext()
        print("Route \(name) saved")
        completion(route)
    }
    
    func fetchRoutes() -> [Route] {
        let context = container.viewContext

        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Error getting routes \(error)")
        }
        return []
    }
    
    func fetchRoute(id:Int16) -> Route?{
        let context = container.viewContext

        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let result = try context.fetch(fetchRequest)
            let route = result[0]
            return route
        } catch {
            print("Error getting route \(error)")
        }
        return nil
    }
    
    func fetchTotalRoutes() -> Int16 {
        let context = container.viewContext

        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return Int16(result.count)
        } catch {
            print("Error getting routes \(error)")
        }
        return 0
    }
    
    func deleteRoute(id:Int16, completion: @escaping() -> Void){
        let context = container.viewContext

        let fetchRequest : NSFetchRequest<Route> = Route.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)


        do {
            let result = try context.fetch(fetchRequest)
            let route = result[0]
            context.delete(route)
            saveContext()
            completion()
        } catch {
            print("Error getting route \(error)")
        }
    }
}
