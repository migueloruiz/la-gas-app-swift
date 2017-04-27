//
//  BuketMapDirections.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

//
//  GoogleMapsApiManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/5/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit
import GoogleMaps

class GoogleMapsApiManager: DataBucket {
    
    init() {
        let url = URL(string: "https://maps.googleapis.com/")
        super.init(baseURL: url!)
    }
    
    func getPath(_ start: CLLocationCoordinate2D, end: CLLocationCoordinate2D , completition: @escaping (Result<[String: Any], Error>) -> Void) {

        let params = [
            "origin": "\(start.latitude),\(start.longitude)",
            "destination": "\(end.latitude),\(end.longitude)",
            "mode": "driving"
        ]
        
        let request = Request(path: "/maps/api/directions/json", method: .GET, params: params)
        
        makeConnection(resource: request, completion: { dataResult in
            
            switch dataResult {
            case .Success(let data):
                let decodeJson = decodeJSON(json: data)
                switch decodeJson {
                case .Success(let json):
                    completition( .Success(json) )
                case .Failure(let error):
                    completition(Result<[String: Any], Error>.Failure(error))
                }
            case .Failure(let error):
                completition(Result<[String: Any], Error>.Failure(error))
            }
        })
        
    }

}




