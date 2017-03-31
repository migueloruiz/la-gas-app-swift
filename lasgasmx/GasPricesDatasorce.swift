//
//  GasPricesDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class GasPricesDatasorce: CollectionDatasource {
    override init() {
        super.init()
        objects = [1]

    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [GasPriceCell.self, GasPriceEmptyCell.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        guard (objects?[indexPath.item] as? GasPriceInState) != nil  else {
            return GasPriceEmptyCell.self
        }
        return GasPriceCell.self
    }
    
    func fetchData(){
        let magna = GasPrice(type: .Magna, price: 16.50)
        let premium = GasPrice(type: .Premium, price: 17.50)
        let diesel = GasPrice(type: .Diesel, price: 18.50)
        
        let arrayPreices = [magna, premium, diesel]
        
        let price1 = GasPriceInState(state: "Ciudad de México", city: "Miguel Hidalgo", date: "18 al 20 de Marzo del 2017", prices: arrayPreices)
        let price2 = GasPriceInState(state: "Estado de México", city: "Cuautitlan Izacalli", date: "18 al 20 de Marzo del 2017", prices: arrayPreices)
        let price3 = GasPriceInState(state: "Jalisco", city: "Zapopan", date: "18 al 20 de Marzo del 2017", prices: arrayPreices)
        
        objects = [price1, price2 ,price3]
    }
    
}
