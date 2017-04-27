//
//  GasApiManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit

class GasApiManager: DataBucket {
//    let configManager = (UIApplication.shared.delegate as! AppDelegate).configManager
//    configManager["API_BASE_URL"]
    init(baseUrl: String) {
        let url = URL(string: baseUrl)
        super.init(baseURL: url!)
    }
}



