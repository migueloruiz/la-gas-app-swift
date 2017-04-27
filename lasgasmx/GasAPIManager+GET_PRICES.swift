//
//  GasAPIManager+GET_PRICES.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

extension GasApiManager {
    func getPriceBy(location: GasPriceLocation, completition: @escaping (Result<GasPriceInState, Error>) -> Void) {
        let request = Request(path: "/prices/\(location.state)/\(location.city)", method: .GET, params: nil)
        
        makeConnection(resource: request, completion: { dataResult in
            
            switch dataResult {
            case .Success(let data):
                let decodeJson = decodeJSON(json: data)
                switch decodeJson {
                case .Success(let json):
                    let r = GasPriceInState(priceLocation: location, json: json)
                    completition( .Success(r) )
                case .Failure(let error):
                    completition(Result<GasPriceInState, Error>.Failure(error))
                }
            case .Failure(let error):
                completition(Result<GasPriceInState, Error>.Failure(error))
            }
        })
    }
}
