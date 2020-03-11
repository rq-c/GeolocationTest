//
//  DetailHistoryViewModel.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import Foundation

protocol DetailHistoryViewModelDelegate {
    func deleteRouteSuccess()
}

class DetailHistoryViewModel {
    
    var detailHistoryViewModelDelegate:DetailHistoryViewModelDelegate?
    let detailHistoryModel: DetailHistoryModel
    let coreDataManager: CoreDataManager = CoreDataManager()

    init(detailHistoryModel: DetailHistoryModel) {
        self.detailHistoryModel = detailHistoryModel
    }
    
    func fetchRoute(id:Int16) -> Route?{
        let route = coreDataManager.fetchRoute(id: id)
        return route
    }
    
    func deleteRoute(id:Int16){
        coreDataManager.deleteRoute(id: id) {
            self.detailHistoryViewModelDelegate?.deleteRouteSuccess()
        }
    }
}
