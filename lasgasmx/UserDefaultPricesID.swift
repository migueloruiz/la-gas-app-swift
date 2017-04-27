//
//  UserDefaultPricesID.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/27/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import Foundation

struct  UserDefaultPricesID {
    var indexs: [String]
    
    init() { self.indexs = [] }
    
    init(decode: String) {
        self.indexs = decode.components(separatedBy:",")
    }
    
    func getArray() -> [String] { return indexs }
    
    func count() -> Int { return self.indexs.count }
    
    func encode() -> String {
        return indexs.reduce("", { result, item in
            return (result == "") ? "\(item)" : result + ",\(item)"
        })
    }
    
    func hasId(id: String) -> Bool {
        let filterIndex = indexs.filter({ item in
            return id == item
        })
        return (filterIndex.count == 1) ? true : false
    }
    
    mutating func add(id: String) {
        indexs.append(id)
    }
    
    mutating func delete(id: String) {
        indexs = indexs.filter({ item in return id != item })
    }
   
}
