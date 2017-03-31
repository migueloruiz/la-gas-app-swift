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
        objects = ["0","0", "1"]
    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [GasPriceCell.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        return GasPriceCell.self
    }
    
}
