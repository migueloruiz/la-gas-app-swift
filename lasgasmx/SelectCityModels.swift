//
//  SelectCityModels.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

struct CitysDictionary {
    let dictionary: [String: [String]]
    
    init( data: Data ){
        self.dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: [String]]
    }
    
    func getStates() -> [String] {
        return Array(dictionary.keys).sorted{ $0 < $1 }
    }
    
    func getCitys(in city: String) -> [String] {
        guard let citys = dictionary[city] else {
            return []
        }
        return citys.sorted{ $0 < $1 }
    }
}


struct SelectCityHeadersItems {
    let defaultText: SelectCityHeaderstype
    var isSectionActive: Bool
    var slectedItem: String?
    
    func getText() -> String {
        if let item = slectedItem {
            return item.capitalized
        } else {
            return defaultText.rawValue
        }
    }
}

enum SelectCityHeaderstype: String {
    case State  = "Elige un estado"
    case City  = "Elige una ciudad"
}
