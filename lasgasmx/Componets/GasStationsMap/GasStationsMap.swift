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
    
    let locationManager = CLLocationManager()
    let gasApi = BucketAPI()
    let directionsApi = BuketMapDirections()
    

    var mapView : GMSMapView
    var lastCameraPosition: GMSCameraPosition? = nil
    var selectedMarker: GMSMarker? = nil
    var markers: [GMSMarker] = []
    weak var delegate: GasStationsMapDelegate? = nil
    
    var distance: Int = 2 {
        didSet{ updateStations = true }
    }
    
    var updateStations: Bool = false {
        didSet{
            guard updateStations else { return }
            userCordinates = CLLocationCoordinate2D()
            updateStations = false
        }
    }
    
    var userCordinates = CLLocationCoordinate2D()  {
        willSet(newLocation){
            print("userCordinates")
            guard newLocation.latitude != 0.0 else { return }
            guard userCordinates.latitude == 0.0 else { return }
            print("userCordinates update \(newLocation)")
            mapView.animate(with: GMSCameraUpdate.setTarget(newLocation))
            mapView.animate(toZoom: 15)
            getSattions(location: newLocation)
        }
    }
    
    var directions: GMSPolyline? = nil {
        willSet(new){
            if (directions != nil) {directions!.map = nil}
            guard let pl = new else { return }
            pl.geodesic = true
            pl.strokeWidth = 4
            pl.strokeColor = .softBlue
            pl.map = self.mapView
        }
    }
    
    var searchRegion: GMSCircle? = nil {
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(GasStationsMapController.becomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func becomeActive() { updateStations = true }
    
    func getSattions(location: CLLocationCoordinate2D) {
        
        searchRegion = GMSCircle(position: location, radius: CLLocationDistance(distance * 1000))
        
        gasApi.getGasStationsFor(location: location, distance: distance,completition: { result in
            switch result {
            case .Success(let stations):

                DispatchQueue.main.async {
                    self.cleanMarkers()
                    for station in stations {
                        self.addMarker(station: station)
                    }
                }
                case .Failure(let error):
                    print(error)
            }
        })
    }
    
    func getAveregeFor(type: FuelType) -> Float {
        var ranges: [String: Int] = [:]
        for marker in markers {
            if let station = marker.userData as? GasStation {
                if let price = station.getPriceOf(type: type) {
                    let key = String(price.price)
                    if (ranges[key] == nil) {
                        ranges[key] = 1
                    } else {
                        ranges[key] = ranges[key]! + 1
                    }
                }
            }
        }
        
        var count = 0
        var modaResult = ""
        for (keys, moda) in ranges {
            if moda >  count{
                count = moda
                modaResult = keys
            }
        }
        
        return Float(modaResult)!
    }
    
    func filterBy(type: FuelType) {
//        let avg = getAveregeFor(type: type)
//        for marker in markers {
//            if let station = marker.userData as? GasStation {
//                if let price = station.getPriceOf(type: type) {
//                    marker.icon = price.price < avg ? #imageLiteral(resourceName: "genericLocationIcon") : #imageLiteral(resourceName: "locationNoData")
//                } else {
//                    marker.icon = #imageLiteral(resourceName: "locationNoData")
//                }
//            }
//        }

        for (index, marker) in markers.enumerated() {
            if let station = marker.userData as? GasStation {
                if let price = station.getPriceOf(type: type) {
                    let alpha = Double(index) / Double(markers.count)
                    marker.icon =  #imageLiteral(resourceName: "locationIcon").alpha( CGFloat(alpha) )
                    
                } else {
                    marker.icon = #imageLiteral(resourceName: "locationNoData")
                }
            }
        }

    }
    
    func setMapInUserPosition() {
        // TODO: hacer esto una funcion individual
        mapView.animate(with: GMSCameraUpdate.setTarget(userCordinates))
        mapView.animate(toZoom: 15)
    }
    
    func setUserLocation(withLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        mapView.camera = camera
    }
    
    func addMarker(station: GasStation) {
        let marker = GMSMarker(position: station.location)
        let image = station.pricesAreValid() ? #imageLiteral(resourceName: "locationIcon") : #imageLiteral(resourceName: "locationNoData")
        marker.icon = image
        marker.userData = station
        marker.map = mapView
        markers.append(marker)
    }
    
    func cleanMarkers() {
        for marker in markers {
            marker.map = nil
        }
        markers.removeAll()
    }
    
    func drawPath(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D, completition: @escaping (GasStationRouteData?) -> Void) {
        lastCameraPosition = mapView.camera
        directionsApi.getPath(start, end: end, completition: { result in
            switch result {
            case .Success(let json):
                DispatchQueue.main.async {
                    completition( GasStationRouteData(json: json) )
                    
                    guard let pl = GMSPolyline(json: json) else { return }
                    self.directions = pl
                    let path = GMSCoordinateBounds(path: pl.path!) // GMSCoordinateBounds(coordinate: start, coordinate: end)
                    self.mapView.animate(with: GMSCameraUpdate.fit(path, withPadding: 60) )
                }
            case .Failure(let error):
                print(error)
            }
        })
    }
    
    func setLastCameraState() {
        self.directions = nil
        guard let lt = lastCameraPosition else { return }
        self.mapView.animate(with: GMSCameraUpdate.setCamera(lt) )
    }
    
}

extension GasStationsMapController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let d = delegate, var gasStation = marker.userData as? GasStation else { return true }
        drawPath(start: userCordinates, end: gasStation.location, completition: { routeData in
            gasStation.set(route: routeData)
            d.gasStation( tappedStation: gasStation )
        })
        return true
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        guard let d = delegate else { return }
        d.gasStation(tappedStation: nil)
        setLastCameraState()
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
                let path = GMSPath.init(fromEncodedPath: routeOverviewPolyline["points"]!)
                polylineArray.append(path!)
            }
        }
        self.init(path: polylineArray.first)
    }
}


