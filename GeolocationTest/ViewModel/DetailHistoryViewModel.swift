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
    
    func deleteRoute(){
        coreDataManager.deleteRoute()
        self.detailHistoryViewModelDelegate?.deleteRouteSuccess()
    }
}
