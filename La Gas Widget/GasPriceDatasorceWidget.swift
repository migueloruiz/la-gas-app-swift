//
//  GasPriceDatasorceWidget.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class GasPricesDatasorce: CollectionDatasource {
    
    // TODO: hacer injectable la URL del API
    lazy var gasApi = GasApiManager(baseUrl: "https://lagasmx.herokuapp.com")
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [GasPriceCell.self, GasPriceEmptyCell.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        guard (objects?[indexPath.item] as? GasPriceInState) != nil  else { return GasPriceEmptyCell.self }
        return GasPriceCell.self
    }
    
    func fetchStroage(){
        // TODO: Obtener de UserSetings
//        var prices = storageManager.fetchAllAsGasPrices() as [AnyObject]
//        if prices.count < 5 { prices.append(1 as AnyObject) }
//        objects = prices
//        updateDatasorce()
    }
    
    func updateStorageItems() {
//        let entitys = storageManager.fetchAll()
//        
//        for entity in entitys {
//            guard entity.canUpdate() else { continue }
//            let location = GasPriceLocation(state: entity.state!, city: entity.city!)
//            gasApi.getPriceBy(location: location, completition: { dataResult in
//                switch dataResult {
//                case .Success(let data):
//                    DispatchQueue.main.async {
//                        entity.update(with: data)
//                        self.storageManager.saveChanges()
//                        self.fetchStroage()
//                    }
//                case .Failure:
//                    break
//                }
//            })
//        }
    }
    
    func updateCarrousell() {
        fetchStroage()
        updateStorageItems()
    }
    
}

