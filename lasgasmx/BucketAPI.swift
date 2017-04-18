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
        let request = Request(path: "/prices/\(location.state)/\(location.city)", method: .GET)

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
    
    func getGasStations() {
        let request = Request(path: "station?user_long=-99.2047001&user_lat=19.4406926", method: .GET)
        makeConnection(resource: request, completion: { dataResult in
            switch dataResult {
            case .Success(let data):
                print(data)
            case .Failure(let error):
                print(error)
            }
        })
        
    }

}



