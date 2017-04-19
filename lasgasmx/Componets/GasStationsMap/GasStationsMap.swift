//
//  GasStationsMap.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import GoogleMaps


let kMapStyle = "[{\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.land_parcel\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.neighborhood\",\"stylers\": [{\"visibility\": \"off\"}]}]"

class GasStationsMapController: NSObject {
    
    var selectedMarker: GMSMarker? = nil
    var mapView : GMSMapView
    let locationManager = CLLocationManager()
    let api = BucketAPI()
    
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
            // TODO: Handel error
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
}

extension GasStationsMapController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = UIView(frame: CGRect(x: 0, y: -5, width: 170, height: 100))
        infoWindow.backgroundColor = .cyan
        return infoWindow
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap marker \(marker.userData)")
        
        selectedMarker = marker
        
        // remove color from currently selected marker
        if let selectedMarker = mapView.selectedMarker {
            selectedMarker.icon = GMSMarker.markerImage(with: nil)
        }
        
        // select new marker and make green
        mapView.selectedMarker = marker
        marker.icon = GMSMarker.markerImage(with: UIColor.green)
        
        // tap event handled by delegate
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        guard let marker = selectedMarker else { return }
        marker.icon = UIImage(named: "locationIcon")
    }
}

extension GasStationsMapController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userCordinates = manager.location!.coordinate as CLLocationCoordinate2D
    }
}


