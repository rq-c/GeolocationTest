//
//  DetailHistoryViewController.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit

class DetailHistoryViewController: UIViewController {

    var viewModel: DetailHistoryViewModel! {
        didSet{
            navigationItem.title = viewModel.detailHistoryModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
