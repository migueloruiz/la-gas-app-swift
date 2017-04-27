//
//  GasPriceModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

enum FuelType: String {
    case Magna = "Magana"
    case Premium = "Premium"
    case Diesel = "Diesel"
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
