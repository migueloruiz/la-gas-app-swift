//
//  SelectCityDatasource.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/31/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class SelectCityDatasorce: CollectionDatasource {
    
    var states: [String] = []
    var citys = [
        "Izcalli", "Izcalli",
        "Izcalli", "Izcalli",
        ]
    
    var headers: [SelectCityHeadersItems]
    
    override init() {
        headers = [
            SelectCityHeadersItems(defaultText: .State, isSectionActive: true, slectedItem: nil),
            SelectCityHeadersItems(defaultText: .City, isSectionActive: false, slectedItem: nil)
        ]
        super.init()
    }
    
    override func cellClasses() -> [CollectionDatasourceCell.Type] {
        return [SelectCityCell.self]
    }
    
    override func headerClasses() -> [CollectionDatasourceCell.Type]? {
        return [SelectCityHeader.self]
    }
    
    override func cellClass(_ indexPath: IndexPath) -> CollectionDatasourceCell.Type? {
        return SelectCityCell.self
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        // TODO: esto s epuede mejorrar
        return headers[section].isSectionActive ? (section > 0) ?  citys.count : states.count : 0
    }
    
    override func numberOfSections() -> Int {
        return (headers[0].slectedItem == nil || headers[0].isSectionActive) ? 1 : 2
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return (indexPath.section > 0) ?  citys[indexPath.item] : states[indexPath.item]
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return headers[section]
    }
    
    func fetchData(){
        // TODO: esto va en un buket o conection
        let path = Bundle.main.path(forResource: "locations", ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        
        
        // TODO esto va en un parser
        let json = try? JSONSerialization.jsonObject(with: data as Data, options: [])
        
        // TODO pasar esto aun servicio que regrese estados y ciudades
        // getStates()
        // getCitys(in: String)
        
        if let dictionary = json as? [String: [String]] {
            states = Array(dictionary.keys)
            print(dictionary["ESTADO DE MÉXICO"]!)
        }
        
        updateDatasorce()
    }
    
    func setItemInHeader(whit index: Int, slected: String) {
        headers[index].isSectionActive = false
        headers[index].slectedItem = slected
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

