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
    
    var userCordinates = CLLocationCoordinate2D() {
        didSet{
            guard updateUserCordinates else { return    }
            mapView.animate(with: GMSCameraUpdate.setTarget(userCordinates))
            updateUserCordinates = true
        }
    }
    var updateUserCordinates = false
    
    init(map: GMSMapView) {
        self.mapView = map
        super.init()
        mapView.delegate = self
        getSattions()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        mapView.isMyLocationEnabled = true
        
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        setUserLocation(withLatitude: 19.4406926, longitude: -99.2047001, zoom: 14)
        
    }
    
    func getSattions() {
//        addMarker()
    }
    
    func setMapInUserPosition() { updateUserCordinates = false }
    
    func setUserLocation(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        // withLatitude: 19.4406926, longitude: -99.2047001, zoom: 17
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
    
    func addMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(19.4406926, -99.2047001)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "locationIcon")
        
        var myData = Dictionary<String, Any>()
        myData["description"] = "The description"
        myData["number"] = 1
        marker.userData = myData
        
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
        print("didTap marker \(marker.title)")
        
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


