//
//  DataBucket.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

protocol ConnectBucketDelegate: class {
    func makeConnection(resource: Request, completion: @escaping (Result<Data, Error>) -> Void)
}

class DataBucket {
    internal let session: URLSession
    internal let baseURL: URL
    
    init(baseURL: URL, session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.baseURL = baseURL
        self.session = session
    }
}

extension DataBucket: ConnectBucketDelegate {
    internal func makeConnection(resource: Request, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = resource.toRequest(baseURL: baseURL)
        session.dataTask(with: request) { (data, response, error) in
            
            guard let d = data else {
                completion(.Failure(.Network(error!.localizedDescription)))
                return
            }
                
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.Failure(.Status("No Response")))
                return
            }
            
            guard httpResponse.statusCode < 400 else {
                completion(.Failure(.Status("Error statusCode: \(httpResponse.statusCode)")))
                return
            }
            
            completion(.Success(d))
        }.resume()
    }
}

protocol ConnectLocalBucketDelegate: class {
    func makeConnection(completion: @escaping (Result<Data, Error>) -> Void)
}

class LocalDataBucket {
    internal let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
}

extension LocalDataBucket: ConnectLocalBucketDelegate {
    func makeConnection(completion: @escaping (Result<Data, Error>) -> Void) {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        completion(.Success(data as Data))
    }
}
