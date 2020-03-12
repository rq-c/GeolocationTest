//
//  MapManager.swift
//  GeolocationTest
//
//  Created by Ramón Quiñonez on 11/03/20.
//  Copyright © 2020 rq-c. All rights reserved.
//

import MapKit

class MapManager {
    
    static func addAnnotation(title:String, latitude:Double, longitude:Double)-> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = "Coordinates:\n\(latitude)\n\(longitude)"
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                                        longitude: CLLocationDegrees(longitude))
        
        return annotation
    }
    
    static func getCoordinates(route:Route) -> (latitudes: [Double], longitudes: [Double])?{
        guard let locations = route.locations, locations.count > 0 else { return nil }

        let latitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.latitude
        }

        let longitudes = locations.map { location -> Double in
            let location = location as! Location
            return location.longitude
        }
        
        return(latitudes, longitudes)
    }
    
    
    static func mapRegion(route:Route) -> MKCoordinateRegion? {
        let coordinates = getCoordinates(route: route)
        let latitudes = coordinates?.latitudes
        let longitudes = coordinates?.longitudes

        let maxLat = latitudes!.max()!
        let minLat = latitudes!.min()!
        let maxLong = longitudes!.max()!
        let minLong = longitudes!.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                      longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 2.2,
                longitudeDelta: (maxLong - minLong) * 2.2)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    static func renderPolyline(rendererFor overlay: MKOverlay)->MKOverlayRenderer{
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let lineRenderer = MKPolylineRenderer(polyline: polyline)
        lineRenderer.strokeColor = .darkGray
        lineRenderer.lineWidth = 5
        return lineRenderer
    }
    
    static func polyLine(route:Route) -> [MKPolyline] {
        
        let locations = route.locations?.array as! [Location]
        var coordinates: [(CLLocation, CLLocation)] = []

        for (first, second) in zip(locations, locations.dropFirst()) {
            let start = CLLocation(latitude: first.latitude, longitude: first.longitude)
            let end = CLLocation(latitude: second.latitude, longitude: second.longitude)
            coordinates.append((start, end))
        }

        var segments: [MKPolyline] = []
        for (start, end) in coordinates {
            let coords = [start.coordinate, end.coordinate]
            let segment = MKPolyline(coordinates: coords, count: 2)
            segments.append(segment)
        }
        return segments
    }
    
}
