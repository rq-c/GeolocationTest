//
//  HistoryViewModel.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import Foundation

class HistoryViewModel {
    
    let historyModel: HistoryModel
    let coreDataManager: CoreDataManager = CoreDataManager()

    init(historyModel: HistoryModel) {
        self.historyModel = historyModel
    }
    
    func fetchRoutes()->[Route]{
        return coreDataManager.fetchRoutes()
    }
    
}
