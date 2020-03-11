//
//  DetailHistoryViewController.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 08/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import UIKit
import MapKit

class DetailHistoryViewController: UIViewController {

    var viewModel: DetailHistoryViewModel! {
        didSet{
            viewModel.detailHistoryViewModelDelegate = self
            navigationItem.title = viewModel.detailHistoryModel.title
        }
    }
    
    var alertAction:AlertAction! {
        didSet{
            alertAction.alertActionDelegate = self
        }
    }
    var route:Route!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setData()
    }
    
    private func setData(){
        alertAction = AlertAction()
        let distance = Measurement(value: route.distance, unit: UnitLength.meters)
        let formattedDistance = FormatValues.distance(distance)
        let formattedTime = FormatValues.time(Int(route.time))
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        dateLabel.text = "Date: \(Date().toString(date: route.date!))"
    }
    
    @IBAction func shareActionTapped(_ sender: Any) {
        alertAction.showShareAlert(view: self, title: "")
    }
    
    @IBAction func removeActionTapped(_ sender: Any) {
        alertAction.showSimpleAlert(view: self, title: "Route: ", message: "Are you sure you want to delete this route?")
    }
    
}

extension DetailHistoryViewController: DetailHistoryViewModelDelegate{
    func deleteRouteSuccess() {
        
    }
}

extension DetailHistoryViewController: AlertActionDelegate{
    func accept() {
        viewModel.deleteRoute(id: route.id)
        navigationController?.popViewController(animated: true)
    }
    
    func restart() {}
}
