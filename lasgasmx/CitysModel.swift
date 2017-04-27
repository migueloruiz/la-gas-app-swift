//
//  CitysModel.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

/// Estructra para el manejo de estados y ciudades obtenidas del archivo local locations.json
struct CitysDictionary {
    private let dictionary: [String: [String]]
    
    
    ///Initializes a new CitysDictionary with the provided data.
    ///- parameters:
    ///   - json: Bytes provenientes del archivo locations.json
    init?( json: Data ){
        let decodedJSON = decodeJSON(json: json)
        
        switch decodedJSON {
        case .Success(let jsonData):
            self.dictionary = jsonData as! [String: [String]]
        case .Failure( _):
            return nil
        }
    }
    
    /// Regresa un arreglo de todos los estados disponibles
    public func getStates() -> [String] {
        return Array(dictionary.keys).sorted{ $0 < $1 }
    }
    
    ///Regresa un arreglo de todos las ciudades disponibles dentro del estado proporcionado
    ///- parameters:
    /// - state: Estado del que se desean obtener ciudades, consultar *getStates()*
    public func getCitys(in state: String) -> [String] {
        guard let citys = dictionary[state] else { return [] }
        return citys.sorted{ $0 < $1 }
    }
}
