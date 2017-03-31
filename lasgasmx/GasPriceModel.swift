//
//  GasPriceModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/30/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

struct GasPrice {
    var state: String
    var city: String
    
    func getText() -> String {
        return "\(city), \(state)"
    }
}

enum FuelType: String {
    case Magna = "Magana"
    case Premium = "Premium"
    case Diesel = "Diesel"
}
