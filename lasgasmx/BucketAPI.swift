//
//  BucketAPI.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit

class BucketAPI: DataBucket {
    
    let configManager = (UIApplication.shared.delegate as! AppDelegate).configManager;
    
    init() {
        let url = URL(string: configManager["API_BASE_URL"])
        super.init(baseURL: url!)
    }
    
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
    
    func getGasStations(completition: @escaping (Result<[GasStation], Error>) -> Void) {
        
        let params = [
            "user_long": "-99.2047001",
            "user_lat": "19.4406926"
        ]
        let request = Request(path: "/station", method: .GET, params: params)
        
        makeConnection(resource: request, completion: { dataResult in
            switch dataResult {
                case .Success(let data):
                    let decodeJson = decodeJSON(json: data)
                    switch decodeJson {
                        case .Success(let json):
                            let r = GasStation.getArray(json: json)
                            completition( .Success(r) )
                        case .Failure(let error):
                            completition(Result<[GasStation], Error>.Failure(error))
                    }
                case .Failure(let error):
                    completition(Result<[GasStation], Error>.Failure(error))
            }
        })
    }

}



