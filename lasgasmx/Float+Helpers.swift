//
//  Float+Helpers.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/7/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

extension Float {
    var asPesos: String  { return "$ \(String(format: "%.2f", self))" }
    var asLiters: String  { return "\(String(format: "%.1f", self)) L" }
}
