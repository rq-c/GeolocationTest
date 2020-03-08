//
//  MapViewModel.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 3/4/20.
//  Copyright © 2020 Ramón Quiñonez. All rights reserved.
//

import Foundation

protocol MapViewModelDelegate {
    func saveRouteSuccess()
}

class MapViewModel {
    var mapViewModelDelegate: MapViewModelDelegate?
    let mapModel: MapModel
    let coreDataManager: CoreDataManager = CoreDataManager()
    var isInProgress: Bool = false
    
    init(mapModel: MapModel) {
        self.mapModel = mapModel
    }
    
    func saveRoute(name: String, distance: Double, time:Double){
        coreDataManager.createRoute(name: name, distance: distance, time: time) {
            self.mapViewModelDelegate?.saveRouteSuccess()
        }
    }
    
    func changeStatusProgress(){
        isInProgress = !isInProgress
    }
}
