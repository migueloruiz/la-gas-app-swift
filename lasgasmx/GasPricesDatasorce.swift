//
//  GasPricesDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class GasPricesDatasorce: CollectionDatasource {
    
    let storageManager = GasPriceStorageManager()
    let apiBucket = BucketAPI()
    
    override init() {
        super.init()
        
        fetchStroage()
        storageManager.updateAll(edit: { (item) -> Bool in
            let priceLocation = GasPriceLocation(state: item.state!, city: item.city! )
            apiBucket.getPriceBy(location: priceLocation, completition: { result in
                switch result {
                case .Success(let data):
                    print(data)
                case .Failure(let error):
                    print(error)
                }
            })
            return true
        }, complited: {
            print("Done")
            fetchStroage()
        })
        
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
    
    func fetchStroage(){
//        let priceLocation = GasPriceLocation(state: "CIUDAD DE MÉXICO", city:"MIGUEL HIDALGO")
//        storageManager.newGasPrice(location: priceLocation)
        var prices = storageManager.fetchAll() as [AnyObject]
        if prices.count < 5 { prices.append(1 as AnyObject) }
        objects = prices
    }
    
//    func fetchLocation(item: GasPriceEntity) -> Bool {
////        let priceLocation = GasPriceLocation(state: item.state!, city: item.city! )
////        apiBucket.getPriceBy(location: priceLocation, completition: { result in
////            switch result {
////                case .Success(let data):
////                    print(data)
////                    item(true)
////                case .Failure(let error):
////                    print(error)
////                    item = false
////            }
////        })
//    }
    
}
