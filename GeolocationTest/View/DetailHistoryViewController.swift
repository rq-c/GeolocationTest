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
            viewModel.detailHistoryViewModelDelegate = self
            navigationItem.title = viewModel.detailHistoryModel.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareActionTapped(_ sender: Any) {
        AlertAction().showShareAlert(view: self, title: "")
    }
    
    @IBAction func removeActionTapped(_ sender: Any) {
        AlertAction().showSimpleAlert(view: self, title: "Route: ", message: "Are you sure you want to delete this route?")
    }
    
}

extension DetailHistoryViewController: DetailHistoryViewModelDelegate{
    func deleteRouteSuccess() {
        
    }
}

extension DetailHistoryViewController: AlertActionDelegate{
    func accept() {
        viewModel.deleteRoute()

    }
    
    func restart() {}
    
    
}
