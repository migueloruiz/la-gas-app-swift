//
//  JsonParse.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

func decodeJSON(data: Data) -> Result<[String: Any], Error> {
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        return .Success(json)
    }
    catch let error {
        return .Failure(.Parser(error.localizedDescription))
    }
}
