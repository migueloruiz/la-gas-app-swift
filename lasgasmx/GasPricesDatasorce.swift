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
    
    override init() {
        super.init()
        fetchStroage()
        updateStorageItems()
    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [GasPriceCell.self, GasPriceEmptyCell.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        guard (objects?[indexPath.item] as? GasPriceInState) != nil  else { return GasPriceEmptyCell.self }
        return GasPriceCell.self
    }
    
    func fetchStroage(){
        var prices = storageManager.fetchAllAsGasPrices() as [AnyObject]
        if prices.count < 5 { prices.append(1 as AnyObject) }
        objects = prices
    }
    
    func updateStorageItems() {
        let apiBucket = BucketAPI()
        let entitys = storageManager.fetchAll()
        
        for entity in entitys {
            let location = GasPriceLocation(state: entity.state!, city: entity.city!)
            apiBucket.getPriceBy(location: location, completition: { dataResult in
                switch dataResult {
                    case .Success(let data):
                        entity.update(with: data)
                        self.storageManager.saveChanges()
                        self.fetchStroage()
                    case .Failure:
                        break
                    }
            })
        }
    }
    
}
