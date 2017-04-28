//
//  GasApiManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit

class GasApiManager: DataBucket {
    
    var config: URLSessionConfiguration = {
        let cf = URLSessionConfiguration.default
        cf.timeoutIntervalForRequest = 4
        cf.timeoutIntervalForResource = 4
        return cf
    }()
    
    init(baseUrl: String) {
        let url = URL(string: baseUrl)
        super.init(baseURL: url!, session: URLSession(configuration: config))
    }
}



