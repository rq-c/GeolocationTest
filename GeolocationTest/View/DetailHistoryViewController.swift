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
            route = viewModel.detailHistoryModel.route
            navigationItem.title = route.name
        }
    }
    
    var alertAction:AlertAction! {
        didSet{
            alertAction.alertActionDelegate = self
        }
    }
    var route:Route!
    
    @IBOutlet weak var mapView: MKMapView!
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
        let distance = Measurement(value: route.distance, unit: UnitLength.meters)
        let formattedDistance = FormatValues.distance(distance)
        let formattedTime = FormatValues.time(Int(route.time))
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        dateLabel.text = "Date: \(route.date!.toString())"
        
        loadMap()
    }
    private func addAnnotationsOnMap(){
        let coordinates = MapManager.getCoordinates(route: route)
        let latitudes = coordinates!.latitudes
        let longitudes = coordinates!.longitudes
        
        let initAnnotation      = MapManager.addAnnotation(title: "Init point", latitude: latitudes.first!, longitude: longitudes.first!)
        let finishAnnotation    = MapManager.addAnnotation(title: "Finish point", latitude: latitudes.last!, longitude: longitudes.last!)
        
        mapView.addAnnotations([initAnnotation, finishAnnotation])
    }
    
    private func loadMap() {
        guard
            let locations = route.locations,
            locations.count > 0,
        let region = MapManager.mapRegion(route: route)
        else {
          let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this run has no locations saved",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          present(alert, animated: true)
          return
        }
        addAnnotationsOnMap()
        mapView.setRegion(region, animated: true)
        mapView.addOverlays(MapManager.polyLine(route: route))
    }

    
    @IBAction func shareActionTapped(_ sender: Any) {
        alertAction = AlertAction(alert: Alert(view: self, title: "", message: ""))
        alertAction.showShareAlert()
    }
    
    @IBAction func removeActionTapped(_ sender: Any) {
        alertAction = AlertAction(alert: Alert(view: self, title: "Route", message: "Are you sure you want to delete this route?"))
        alertAction.showSimpleAlert()
    }
}

// MARK: - Map View Delegate
extension DetailHistoryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MapManager.renderPolyline(rendererFor: overlay)
    }
}

// MARK: - DetailHistoryViewModel Delegate
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
