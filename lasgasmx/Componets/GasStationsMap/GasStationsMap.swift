//
//  GasStationsMap.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import GoogleMaps

class GasStationsMapController: NSObject {
    
    var mapView : GMSMapView
    
    init(map: GMSMapView) {
        self.mapView = map
        super.init()
        mapView.delegate = self
    }
}

extension GasStationsMapController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 100))
        infoWindow.backgroundColor = .cyan
        return infoWindow
    }
}

