//
//  BucketAPI.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit
import CoreLocation

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
    
    func getGasStationsFor(location: CLLocationCoordinate2D , distance: Int, completition: @escaping (Result<[GasStation], Error>) -> Void) {
        
        let params = [
            "user_long": "\(location.longitude)",
            "user_lat": "\(location.latitude)",
            "range": "\(distance)"
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



