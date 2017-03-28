//
//  PrivateKeysManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/27/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

class ConfigKeysManager: NSObject {
    
    let configKeys :[String: AnyObject]
    
    override init() {
        guard let path = Bundle.main.path(forResource: "PrivateKeys", ofType: "plist") else {
            self.configKeys = [String: AnyObject]()
            print("ERROR: PrivateKeys.plit not found")
            return
        }
        
        self.configKeys = NSDictionary(contentsOfFile: path) as! [String: AnyObject]!
    }
    
    func getConfigValue(byKey key: String) -> String {
        guard configKeys[key] != nil else { return "" }
        return self.configKeys[key]! as! String
    }
    
}
