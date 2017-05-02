//
//  GasStationsMap.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import GoogleMaps

protocol GasStationsMapDelegate: class {
    func gasStation( tappedStation: GasStation? )
}

let kMapStyle = "[{\"elementType\": \"labels\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.land_parcel\",\"stylers\": [{\"visibility\": \"off\"}]},{\"featureType\": \"administrative.neighborhood\",\"stylers\": [{\"visibility\": \"off\"}]}]"

class GasStationsMapController: NSObject {

    internal let locationManager = CLLocationManager()
    lazy var gasApi: GasApiManager = {
        let configManager = (UIApplication.shared.delegate as! AppDelegate).configManager
        return GasApiManager(baseUrl: configManager["API_BASE_URL"])
    }()
    internal let directionsApi = GoogleMapsApiManager()
    
    public var mapView : GMSMapView
    internal var lastCameraPosition: GMSCameraPosition? = nil
    internal var selectedMarker: GMSMarker? = nil
    internal var markers: [GMSMarker] = []
    public weak var delegate: GasStationsMapDelegate? = nil
    
    public var waitForLocationUpdate: Bool = false
    
    public var distance: Int = 2 {
        didSet{ updateUserLocation() }
    }
    
    internal var userCordinates = CLLocationCoordinate2D()  {
        willSet(newLocation){
            guard newLocation.latitude != 0.0 else { return }
            setCameraIn( cordinates: newLocation )
            getSations(location: newLocation)
            waitForLocationUpdate = false
        }
    }
    
    internal var directions: GMSPolyline? = nil {
        willSet(new){
            if (directions != nil) {directions!.map = nil}
            guard let pl = new else { return }
            pl.geodesic = true
            pl.strokeWidth = 4
            pl.strokeColor = .softBlue
            pl.map = self.mapView
        }
    }
    
    internal var searchRegion: GMSCircle? = nil {
        willSet(new){
            if (searchRegion != nil) {searchRegion!.map = nil}
            guard let c = new else { return }
            c.strokeColor = UIColor.softBlue.withAlphaComponent(0.2)
            c.strokeWidth = 2
            c.fillColor = UIColor.softBlue.withAlphaComponent(0.07)
            c.map = mapView
        }
    }

    init(map: GMSMapView) {
        self.mapView = map
        super.init()
        
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(GasStationsMapController.askForUserLocation), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: Update Locations
    public func updateUserLocation() {
        guard let location = locationManager.location else { return }
        userCordinates = location.coordinate
    }
    
    public func askForUserLocation() { waitForLocationUpdate = true }
    
    // MARK: getSations
    internal func getSations(location: CLLocationCoordinate2D) {
        UIToast.shared.hide()
        UILoadingIndicator.shared.show()
        searchRegion = GMSCircle(position: location, radius: CLLocationDistance(distance * 1000))
        gasApi.getGasStationsFor(location: location, distance: distance,completition: { result in
            switch result {
                case .Success(let stations):
                    DispatchQueue.main.async {
                        self.cleanMarkers()
                        for station in stations { self.addMarker(station: station) }
                        UILoadingIndicator.shared.hide()
                    }
                case .Failure(let error):
                    UILoadingIndicator.shared.hide()
                    // TODO: Print user mesage
                    print(error)
                    UIToast.shared.show(type: .Wifi, message: "Hemos detecado problemas con tu red. Revisa tu conexion e intentalo de nuevo")
            }
        })
    }
    
    // MARK: Set Camera
    internal func setCameraIn( cordinates: CLLocationCoordinate2D ) {
        mapView.animate(with: GMSCameraUpdate.setTarget(cordinates))
        mapView.animate(toZoom: 14)
    }
    public func setCameraInUserPosition() { setCameraIn( cordinates: userCordinates ) }
    
    internal func setLastCameraPosition() {
        self.directions = nil
        guard let lt = lastCameraPosition else { return }
        self.mapView.animate(with: GMSCameraUpdate.setCamera(lt) )
    }
    
    // MARK: Markers function
    internal func addMarker(station: GasStation) {
        let marker = station.getMarker()
        marker.map = mapView
        markers.append(marker)
    }
    
    internal func cleanMarkers() {
        for marker in markers { marker.map = nil }
        markers.removeAll()
    }
}


