//
//  GasStationsMap+Extention.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import GoogleMaps

extension GasStationsMapController {
    class public func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}


extension GasStationsMapController: CLLocationManagerDelegate {
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard waitForLocationUpdate else { return }
        userCordinates = manager.location!.coordinate as CLLocationCoordinate2D
    }
}

extension GasStationsMapController: GMSMapViewDelegate{
    internal func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, completition: @escaping (GasStationRouteData?) -> Void) {
        lastCameraPosition = mapView.camera
        directionsApi.getPath(start, end: end, completition: { result in
            switch result {
            case .Success(let json):
                DispatchQueue.main.async {
                    completition( GasStationRouteData(json: json) )
                    guard let pl = GMSPolyline(json: json) else { return }
                    self.directions = pl
                    let bounds = GMSCoordinateBounds(path: pl.path!) // GMSCoordinateBounds(coordinate: start, coordinate: end)
                    self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 60) )
                }
            case .Failure(let error):
                print(error)
            }
        })
    }
    
    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let d = delegate, var gasStation = marker.userData as? GasStation, let location = locationManager.location else { return true }
        drawPath(start: location.coordinate, end: gasStation.location, completition: { routeData in
            gasStation.set(route: routeData)
            d.gasStation( tappedStation: gasStation )
        })
        return true
    }
    
    internal func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard let d = delegate else { return }
        d.gasStation(tappedStation: nil)
        setLastCameraPosition()
    }
}
