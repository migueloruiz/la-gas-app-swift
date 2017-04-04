//
//  Resourse.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

public typealias RequestHeaders = [String: String]

public enum RequestMethod: String {
    case GET
    case POST
}

public struct Request {
    public let path: String
    public let method: RequestMethod
    public var description: String {
        return "Path:\(path)\nMethod:\(method.rawValue)\n"
    }
}

extension Request {
    public func toRequest(baseURL: URL) -> URLRequest {
        var components = URLComponents(url: baseURL as URL, resolvingAgainstBaseURL: false)
        components?.path = path
        
        let finalURL = components?.url ?? baseURL as URL
        let request = NSMutableURLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        return request as URLRequest
    }
}
