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
        startLocationUpdates()
        setupNavigation()
    }
    
    @IBAction func initRouteButtonTapped(_ sender: Any) {
        if viewModel.isInProgress == false{
            startRun()
            initButton.setTitle("Save route", for: .normal)
            viewModel.changeStatusProgress()
        }else{
            viewModel.saveRoute(name: "Default route", distance: 0.0, time: 0.0)
        }
    }
    
    private func startRun() {
        mapView.removeOverlays(mapView.overlays)
        
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.seconds += 1
            self.updateDisplay()
            
            
        }
        startLocationUpdates()
    }
    
    private func setupNavigation(){
        let historyItemButton = UIBarButtonItem(title: "view history", style: .plain, target: self, action: #selector(viewHistoryItemButtonAction))
        
        navigationItem.setRightBarButton(historyItemButton, animated: true)
    }
    
    private func startLocationUpdates() {
        coreLocationManager.delegate        = self
        coreLocationManager.activityType    = .fitness
        coreLocationManager.distanceFilter  = 10
        coreLocationManager.startUpdatingLocation()
    }
    
    @objc func viewHistoryItemButtonAction(){
        let historyView = Router.createHistoryModule()
        navigationController?.pushViewController(historyView, animated: true)
    }
    
    private func updateDisplay() {
        let formattedDistance = FormatValues.distance(distance)
        let formattedTime = FormatValues.time(seconds)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
    }
}

extension MapViewController: MapViewModelDelegate{
    func saveRouteSuccess() {
        
    }
    
    
}

// MARK: - Location Manager Delegate
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
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
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let lineRenderer = MKPolylineRenderer(polyline: polyline)
        lineRenderer.strokeColor = .blue
        lineRenderer.lineWidth = 5
        return lineRenderer
    }
}
