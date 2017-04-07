//
//  GasPriceModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/30/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

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

struct GasPriceLocation {
    var state: String
    var city: String
}

struct GasPrice {
    var type : FuelType
    var price: Float
    
    static func buildArray(from array: [String: String]) -> [GasPrice]{
        var prices: [GasPrice] = []
        
        if let magna = array["magna"] {
            prices.append(GasPrice(type: .Magna, price: Float(magna) ?? 0 ) )
        }
        
        if let premium = array["premium"] {
            prices.append(GasPrice(type: .Premium, price: Float(premium) ?? 0 ) )
        }
        
        if let diesel = array["diesel"] {
            prices.append(GasPrice(type: .Diesel, price: Float(diesel) ?? 0 ) )
        }
        
        return prices
    }
}

enum FuelType: String {
    case Magna = "Magana"
    case Premium = "Premium"
    case Diesel = "Diesel"
}

// MARK: Coredata Model

extension GasPriceEntity {
    func set(location: GasPriceLocation) {
        self.state = location.state
        self.city = location.city
    }
    
    func update(with data: GasPriceInState) {
        self.state = data.priceLocation.state
        self.city = data.priceLocation.city
        self.dateText = data.date
        self.updatePrices(with: data.prices)
    }
    
    func updatePrices(with prices: [GasPrice]) {
        for price in prices {
            switch price.type {
                case .Magna:
                    self.magna = price.price
                case .Premium:
                    self.premium = price.price
                case .Diesel:
                    self.diesel = price.price
            }
        }
    }
    
    func getStruct() -> GasPriceInState {
        let location = GasPriceLocation(state: self.state!, city: self.city!)
        let date = (self.dateText != nil) ? self.dateText! : ""
        var prices : [GasPrice] = []
        
        let magna = GasPrice(type: .Magna, price: self.magna)
        let premium = GasPrice(type: .Premium, price: self.premium)
        let diesel = GasPrice(type: .Diesel, price: self.diesel)
        
        let id = self.id!
        
        prices.append(magna)
        prices.append(premium)
        prices.append(diesel)
        
        return GasPriceInState(priceLocation: location, date: date, prices: prices, id: id)
    }
}
