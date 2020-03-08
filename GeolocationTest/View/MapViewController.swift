//
//  MapViewController.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 3/4/20.
//  Copyright © 2020 Ramón Quiñonez. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    var viewModel: MapViewModel! {
        didSet{
            navigationItem.title = viewModel.mapModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
}
