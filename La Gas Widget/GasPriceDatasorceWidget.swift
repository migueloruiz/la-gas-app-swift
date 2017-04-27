//
//  GasPriceDatasorceWidget.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class GasPricesDatasorce: CollectionDatasource {
    
    var gasApi: GasApiManager
    var userDefaults: UserDefaultsManager
    
    init(api: GasApiManager, userDefaults: UserDefaultsManager) {
        self.gasApi = api
        self.userDefaults = userDefaults
    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [GasPriceCellNoRounded.self, GasPriceEmptyCell.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        guard (objects?[indexPath.item] as? GasPriceInState) != nil  else { return GasPriceEmptyCell.self }
        return GasPriceCellNoRounded.self
    }
    
    func fetchResurces(completition: @escaping (Bool) -> Void){
        completition(true)
        self.objects = []
        self.updateDatasorce()
        
        let locations = userDefaults.retrieveLocations()
        
        for loc in locations{
            gasApi.getPriceBy(location: loc, completition: { dataResult in
                switch dataResult {
                    case .Success(let data):
                        DispatchQueue.main.async {
                            self.objects?.append(data as AnyObject)
                            self.updateDatasorce()
                            completition(true)
                        }
                    break
                    case .Failure:
                        completition(false)
                    break
                }
            })
        }
    }
}
