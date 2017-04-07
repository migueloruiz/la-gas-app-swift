//
//  CalcResultDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/7/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class CalcResultDatasorce: CollectionDatasource {
    
    var prices: [GasPrice]
    var calc: CalcType = .liters(0) {
        didSet{
            updateDatasorce()
        }
    }
    
    init(prices: [GasPrice]){
        self.prices = prices
    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [CalcResultCell.self]
    }

    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        return CalcResultCell.self
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return prices.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return CalcPrice(price: prices[indexPath.item], type: calc)
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return "Header"
    }

    
}

