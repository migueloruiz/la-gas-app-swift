//
//  GasApiManager+GET_STATIONS.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import CoreLocation

extension GasApiManager {
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
