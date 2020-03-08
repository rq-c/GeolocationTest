//
//  Router.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 3/4/20.
//  Copyright © 2020 Ramón Quiñonez. All rights reserved.
//

import UIKit

class Router{
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    static func createMapModule() -> MapViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "id_mapviewcontroller") as! MapViewController
        
        let mapViewModel = MapViewModel(mapModel: MapModel(title: "Map Module"))
        view.viewModel = mapViewModel
        
        return view
    }
    
    static func createHistoryModule() -> HistoryViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "id_historyviewcontroller") as! HistoryViewController
        
        let historyViewModel = HistoryViewModel(historyModel: HistoryModel(title: "History Module"))
        view.viewModel = historyViewModel
        
        return view
    }
    
    static func createDetailHistoryModule() -> DetailHistoryViewController {
        let view = mainstoryboard.instantiateViewController(withIdentifier: "id_detailhistoryviewcontroller") as! DetailHistoryViewController
        
        let detailHistoryViewModel = DetailHistoryViewModel(detailHistoryModel: DetailHistoryModel(title: "Detail Module"))
        view.viewModel = detailHistoryViewModel
        
        return view
    }
}
