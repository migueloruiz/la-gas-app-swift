//
//  CalcModels.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

struct CalcPrice {
    var price : GasPrice
    var type: CalcType
    
    func calculate() -> String{
        switch type {
        case .liters(let pesos):
            let value = pesos / price.price
            return value.asLiters
        case .pesos(let litros):
            let value = litros * price.price
            return value.asPesos
        }
    }
}

enum CalcType {
    case liters(Float)  // Cuantos pesos equivalen en litros
    case pesos(Float)   // Cuantos litros equivalen en pesos
}

