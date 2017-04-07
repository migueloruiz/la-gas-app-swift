//
//  SelectCityModels.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//


import Foundation

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
