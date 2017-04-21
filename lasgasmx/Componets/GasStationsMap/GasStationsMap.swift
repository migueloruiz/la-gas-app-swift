//
//  GasStationsMap.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import GoogleMaps

protocol GasStationsMapDelegate {
    func gasStation( tappedStation: GasStation? )
}

let kMapStyle = "[{\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.land_parcel\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.neighborhood\",\"stylers\": [{\"visibility\": \"off\"}]}]"

class GasStationsMapController: NSObject {
    
    let locationManager = CLLocationManager()
    let api = BucketAPI()
    let directionsApi = BuketMapDirections()
    var selectedMarker: GMSMarker? = nil
    var mapView : GMSMapView
    var delegate: GasStationsMapDelegate? = nil
    var lastCameraPosition: GMSCameraPosition? = nil
    var directions: GMSPolyline? = nil {
        willSet(new){
            if (directions != nil) {
                directions!.map = nil
            }
        }
    }
    
    var userCordinates = CLLocationCoordinate2D()  {
        willSet(newLocation){
            guard userCordinates.latitude == 0.0 else { return }
            mapView.animate(with: GMSCameraUpdate.setTarget(newLocation))
            mapView.animate(toZoom: 15)
        }
    }
    
    
    init(map: GMSMapView) {
        self.mapView = map
        super.init()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        getSattions()
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // TODO: Handel no permition
        }
        
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func getSattions() {
        api.getGasStations(completition: { result in
            switch result {
            case .Success(let stations):
                DispatchQueue.main.async {
                    for station in stations {
                        self.addMarker(station: station)
                    }
                }
                case .Failure(let error):
                    print(error)
            }
        })
    }
    
    func setMapInUserPosition() {
        
        // TODO: hacer esto una funcion individual
        mapView.animate(with: GMSCameraUpdate.setTarget(userCordinates))
        mapView.animate(toZoom: 15)
    }
    
    func setUserLocation(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        // withLatitude: 19.4406926, longitude: -99.2047001, zoom: 17
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
    
    func addMarker(station: GasStation) {
        let marker = GMSMarker(position: station.location)
        marker.icon = UIImage(named: "locationIcon")
        marker.userData = station
        marker.map = mapView
    }
    
    func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
        lastCameraPosition = mapView.camera
        directionsApi.getPath(start, end: end, completition: { result in
            switch result {
            case .Success(let json):
                DispatchQueue.main.async {
                    guard let pl = GMSPolyline(json: json) else { return }
                    self.directions = pl
                    pl.strokeWidth = 4
                    pl.strokeColor = UIColor.red
                    pl.map = self.mapView
                    let path = GMSCoordinateBounds(coordinate: start, coordinate: end) // GMSCoordinateBounds(path: (pl?.path)!)
                    self.mapView.animate(with: GMSCameraUpdate.fit(path, withPadding: 50) )
                }
            case .Failure(let error):
                print(error)
            }
        })
    }
    
}

extension GasStationsMapController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let d = delegate, let gasStation = marker.userData as? GasStation else { return true }
        drawPath(start: userCordinates, end: gasStation.location)
        d.gasStation( tappedStation: gasStation )
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard let d = delegate else { return }
        d.gasStation(tappedStation: nil)
        self.directions = nil
        self.mapView.animate(with: GMSCameraUpdate.setCamera(lastCameraPosition!) )
    }
}

extension GasStationsMapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCordinates = manager.location!.coordinate as CLLocationCoordinate2D
    }
}


extension GMSPolyline {
    
    convenience init?(json: [String: Any]){
        var polylineArray: [GMSPath] = []
        guard let routes = json["routes"] as? [[String: Any]] else { return nil }
        for route in routes {
            if let routeOverviewPolyline = route["overview_polyline"] as? [String: String] {
                print(routeOverviewPolyline)
                let path = GMSPath.init(fromEncodedPath: routeOverviewPolyline["points"]!)
                polylineArray.append(path!)
            }
        }
        
        self.init(path: polylineArray.first)
    }
}


