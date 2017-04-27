//
//  PrivateKeysManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/27/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

/// Clase para el manejo del archivo XXXXXXX.plit para almacenameinto de Private Keys
///- Note:
/// para utilizar esta clase debe de existir el archivo .plist proporcionado
class PrivateKeysManager {
    
    private let configKeys :[String: AnyObject]
    
    ///Inicializa el nuevo ConfigManager
    ///- parameters:
    ///   - byPlistFile: Nombre del archivo **sin la terninacion .plist**
    init( byPlistFile file: String ) {
        guard let path = Bundle.main.path(forResource: file, ofType: "plist") else {
            self.configKeys = [String: AnyObject]()
            fatalError("ERROR: \(file).plit not found")
        }
        self.configKeys = NSDictionary(contentsOfFile: path) as! [String: AnyObject]!
    }
    
    ///Regresa un string relacionado con el key proporcionado
    /// - parameter key: Referencia de busqueda
    /// - returns: Regresa un String en caso de que la busqueda sea exitosa, de lo contrario llegersa un String vacio
    subscript(key: String) -> String {
        return configKeys[key] != nil ? self.configKeys[key]! as! String : ""
    }
    
}
