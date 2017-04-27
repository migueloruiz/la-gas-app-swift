//
//  GMSPolyline+Extention.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import GoogleMaps

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
