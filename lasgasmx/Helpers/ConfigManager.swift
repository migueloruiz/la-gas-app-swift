//
//  PrivateKeysManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/27/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

class ConfigManager {
    
    let configKeys :[String: AnyObject]
    
    // TODO: Hacer un correcto manejo de errores en la carga de el .plist
    
    init( byPlistFile file: String ) {
        guard let path = Bundle.main.path(forResource: file, ofType: "plist") else {
            self.configKeys = [String: AnyObject]()
            print("ERROR: PrivateKeys.plit not found")
            return
        }
        
        self.configKeys = NSDictionary(contentsOfFile: path) as! [String: AnyObject]!
    }
    
    subscript(key: String) -> String {
        return configKeys[key] != nil ? self.configKeys[key]! as! String : ""
    }
    
}
