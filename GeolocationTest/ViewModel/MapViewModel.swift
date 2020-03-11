//
//  MapViewModel.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 3/4/20.
//  Copyright © 2020 Ramón Quiñonez. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate {
    func saveRouteSuccess(route:Route)
}

class MapViewModel {
    var mapViewModelDelegate: MapViewModelDelegate?
    let mapModel: MapModel
    let coreDataManager: CoreDataManager = CoreDataManager()
    var isInProgress: Bool = false
    
    init(mapModel: MapModel) {
        self.mapModel = mapModel
    }
    
    func saveRoute(name: String, distance: Double, time:Int16, locations:[LocationModel]){
        coreDataManager.createRoute(name: name, distance: distance, time: time, locations: locations) { route in
            self.mapViewModelDelegate?.saveRouteSuccess(route:route)
        }
    }
    

    func changeStatusProgress(){
        isInProgress = !isInProgress
    }
}
