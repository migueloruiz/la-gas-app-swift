//
//  Result.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

enum Result<T, E: Swift.Error> {
    case Success(T)
    case Failure(E)
}

enum Error: Swift.Error {
    case Network(String)
    case Parser(String)
}
