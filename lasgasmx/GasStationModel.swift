//
//  GasStationModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/19/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import CoreLocation

struct GasStation {
    
    let name : String
    let address : String
    let location: CLLocationCoordinate2D
    let prices: [GasPrice]
    
    init(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let address = json["address"] as? String,
            let location = json["location"] as? [String: String],
            let pricesArray = json["prices"] as? [String: String]
        else {
            self.name = ""
            self.address = ""
            self.location = CLLocationCoordinate2D()
            self.prices = []
            return
        }
        
        self.name = name
        self.address = address
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(location["lat"]!)!, longitude: CLLocationDegrees(location["long"]!)!)
        self.prices = GasPrice.buildArray(from: pricesArray)
    }
    
    static func getArray(json:  [String: Any]) -> [GasStation]{
        guard let stations = json["stations"] as? [[String:Any]] else { return [] as [GasStation] }
        return stations.map{GasStation(json: $0)}
    }


}
