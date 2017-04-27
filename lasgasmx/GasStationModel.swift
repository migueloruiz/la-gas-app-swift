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
    var route: GasStationRouteData? = nil
    
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
    
    mutating func set(route newRoute: GasStationRouteData?) {
        self.route = newRoute
    }
    
    func pricesAreValid() -> Bool {
        let sum = prices.reduce(0, { (result, item) in
            return item.price + result
        })
        return sum > 1
    }
    
    func getPriceOf(type: FuelType) -> GasPrice? {
        let filter = prices.filter({ item in
            return item.type == type
        })
        guard let price = filter.first else { return nil }
        guard price.price > 0 else { return nil }
        return price
    }
}

struct GasStationRouteData {
    let time: String
    let distance: String
    let address: String
    
    init?(json: [String: Any]) {
        guard let routes = json["routes"] as? [[String: Any]] else { return nil }
        guard let data = routes.first?["legs"] as? [[String: Any]] else { return nil }
        guard let distanceData = data.first?["distance"] as? [String: Any],
            let durationData = data.first?["duration"] as? [String: Any],
            let address = data.first?["end_address"] as? String else { return nil }
        guard let d = distanceData["text"] as? String,
            let t = durationData["text"] as? String else { return nil }
        
        self.time = t
        self.distance = d
        self.address = address
    }
}
