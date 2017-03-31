//
//  GasPriceModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/30/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

struct GasPriceInState {
    var state: String
    var city: String
    var date: String
    var prices: [GasPrice]
    
    func getText() -> String {
        return "\(city), \(state)"
    }
}

struct GasPrice {
    let type : FuelType
    let price: Float
}

enum FuelType: String {
    case Magna = "Magana"
    case Premium = "Premium"
    case Diesel = "Diesel"
}
