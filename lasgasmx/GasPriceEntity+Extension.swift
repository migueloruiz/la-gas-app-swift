//
//  GasPriceEntity.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

// Core Data entity
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
        self.updateDate = NSDate()
    }
    
    func canUpdate() -> Bool {
        guard  let lastDate = self.updateDate as? Date else { return true }
        
        let calendar = Calendar.current
        
        let lastYear = calendar.component(.year, from: lastDate)
        let lastMonth = calendar.component(.month, from: lastDate)
        let last = calendar.component(.day, from: lastDate)
        
        let todayDate = Date()
        let todayYear = calendar.component(.year, from: todayDate)
        let todayMonth = calendar.component(.month, from: todayDate)
        let today = calendar.component(.day, from: todayDate)
        
        return (todayYear != lastYear) || (todayMonth != lastMonth) || (today != last)
    }
    
    internal func updatePrices(with prices: [GasPrice]) {
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
