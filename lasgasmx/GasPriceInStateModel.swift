//
//  GasPriceInStateModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/30/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

struct GasPriceLocation {
    var state: String
    var city: String
}

struct GasPriceInState {
    var priceLocation: GasPriceLocation
    var date: String
    var prices: [GasPrice]
    
    var id: String?
    
    func getText() -> String {
        return "\(priceLocation.city.capitalized), \(priceLocation.state.capitalized)"
    }
    
    init(priceLocation: GasPriceLocation, date: String, prices: [GasPrice]) {
        self.priceLocation = priceLocation
        self.date = date
        self.prices = prices
    }
    
    init(priceLocation: GasPriceLocation, date: String, prices: [GasPrice], id: String) {
        self.priceLocation = priceLocation
        self.date = date
        self.prices = prices
        self.id = id
    }
    
    init(priceLocation: GasPriceLocation, json: [String: Any]) {
        guard let date = json["date"] as? String, let pricesArray = json["price"] as? [String: String] else {
            self.priceLocation = priceLocation
            self.date = ""
            self.prices = []
            return
        }
        self.priceLocation = priceLocation
        self.date = date
        self.prices = GasPrice.buildArray(from: pricesArray)
    }
}
