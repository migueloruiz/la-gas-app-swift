//
//  Timestamp.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

func generateIdTimestamp() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMddHHmmss"
    return formatter.string(from: Date())
}
