//
//  MapViewController.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 3/4/20.
//  Copyright © 2020 Ramón Quiñonez. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var viewModel: MapViewModel! {
        didSet{
            navigationItem.title = viewModel.mapModel.title
            viewModel.mapViewModelDelegate = self
        }
    }
    
    var alertAction:AlertAction! {
        didSet{
            alertAction.alertActionDelegate = self
        }
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var initButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    /// MARK: - Variables
    private let coreLocationManager = CoreLocationManager.shared
    private var locationList: [CLLocation] = []
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigation()
        coreLocationManager.requestWhenInUseAuthorization()
    }
    
    @IBAction func initRouteButtonTapped(_ sender: Any) {
        if viewModel.isInProgress == false{
            startTour()
            initButton.setTitle("Save route", for: .normal)
            viewModel.changeStatusProgress()
        }else{
            alertAction = AlertAction(alert: Alert(view: self, title: "", message: "You wish finished this route?", descriptionButton: "Save", actionSheet: .actionSheet))
            alertAction.show()
        }
    }
    
    private func startTour() {
        timer?.invalidate()
        mapView.removeOverlays(mapView.overlays)
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
            self.updateDisplay()
        }
        startLocationUpdates()
    }
    
    func restartTour(){
        viewModel.changeStatusProgress()
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        updateDisplay()
        timer?.invalidate()
        coreLocationManager.stopUpdatingLocation()
        self.mapView.removeOverlays(self.mapView.overlays)

    }
    
    private func setupNavigation(){
        let historyItemButton = UIBarButtonItem(title: "view history", style: .plain, target: self, action: #selector(viewHistoryItemButtonAction))
        navigationItem.setRightBarButton(historyItemButton, animated: true)
    }
    
    private func startLocationUpdates() {
        coreLocationManager.delegate        = self
        coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        coreLocationManager.startUpdatingLocation()
    }
    
    @objc func viewHistoryItemButtonAction(){
        let historyView = Router.createHistoryModule()
        navigationController?.pushViewController(historyView, animated: true)
    }
    
    private func updateDisplay() {
        let title:String = viewModel.isInProgress == false ? "Start tour" : "Save route"
        initButton.setTitle(title, for: .normal)
        
        let formattedDistance = FormatValues.distance(distance)
        let formattedTime = FormatValues.time(seconds)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
    }
}

extension MapViewController: MapViewModelDelegate{
    func saveRouteSuccess(route: Route) {
        restartTour()
        let detailHistory = Router.createDetailHistoryModule(detailHistoryModel: DetailHistoryModel(route: route))
        detailHistory.route = route
        navigationController?.pushViewController(detailHistory, animated: true)
    }
}

// MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 100 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                mapView.addOverlay(MKPolyline(coordinates: [lastLocation.coordinate, newLocation.coordinate],
                                              count: 2))
                
                let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
            }
            locationList.append(newLocation)
        }
    }
}

// MARK: - Map View Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return  MapManager.renderPolyline(rendererFor: overlay)
    }
}

// MARK: - Alert Action Delegate
extension MapViewController: AlertActionDelegate{
    func accept() {
        var locations:[LocationModel] = []
        for location in locationList{
            locations.append(LocationModel(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        let ac = UIAlertController(title: "Nombre de tu recorrido:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Aceptar", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            // do something interesting with "answer" here
            self.viewModel.saveRoute(name: answer.text!, distance: self.distance.value, time: Int16(self.seconds), locations: locations)

        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func restart() {
        startTour()
    }

}

