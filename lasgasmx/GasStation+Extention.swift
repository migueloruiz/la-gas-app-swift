//
//  GasStation+Extention.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import GoogleMaps
import CoreLocation

extension GasStation {
    func getMarker() -> GMSMarker {
        let marker = GMSMarker(position: self.location)
        let image = self.pricesAreValid() ? #imageLiteral(resourceName: "locationIcon") : #imageLiteral(resourceName: "locationNoData")
        marker.icon = image
        marker.userData = self
        return marker
    }
}
