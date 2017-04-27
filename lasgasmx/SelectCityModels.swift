//
//  SelectCityModels.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/4/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//


import Foundation

enum SelectCityHeaderstype: String {
    case State  = "Elige un estado"
    case City  = "Elige una ciudad"
}

struct SelectCityHeadersItems {
    let defaultText: SelectCityHeaderstype
    var isSectionActive: Bool
    var slectedItem: String?
    
    func getText() -> String {
        guard let item = slectedItem else { return defaultText.rawValue }
        return item.capitalized
    }
}
