//
//  SelectCityDatasource.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/31/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class SelectCityDatasorce: CollectionDatasource {
    
    var citysDictionary: CitysDictionary? = nil
    var filterQuery: String? = nil {
        didSet{ self.updateDatasorce() }
    }
    
    var states: [String] = []
    var citys: [String] = []
    var filter: [String]? = nil
    
    var headers: [SelectCityHeadersItems]
    
    override init() {
        self.headers = [
            SelectCityHeadersItems(defaultText: .State, isSectionActive: true, slectedItem: nil),
            SelectCityHeadersItems(defaultText: .City, isSectionActive: false, slectedItem: nil)
        ]
        super.init()
    }
    
    init (location: GasPriceLocation) {
        self.headers = [
            SelectCityHeadersItems(defaultText: .State, isSectionActive: false, slectedItem: location.state),
            SelectCityHeadersItems(defaultText: .City, isSectionActive: false, slectedItem: location.city)
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
        let isSectionActive = headers[section].isSectionActive
        if !isSectionActive { return 0 }
        
        guard let query = filterQuery else {
             return (section > 0) ?  citys.count : states.count
        }
        
        let arrayToFilter = (section > 0) ? citys : states
        filter = arrayToFilter.filter { city in
            return city.lowercased().contains(query.lowercased())
        }
        
        return filter!.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return (filterQuery != nil) ? filter?[indexPath.item] : (indexPath.section > 0) ?  citys[indexPath.item] : states[indexPath.item]
    }
    
    override func numberOfSections() -> Int {
        return (headers[0].slectedItem == nil || headers[0].isSectionActive) ? 1 : 2
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return headers[section]
    }
    
    func getData() {
        if citysDictionary == nil {
            fetchData()
        } else {
            setCitys()
        }
    }
    
    func fetchData(){
        let localData = LocalDataBucket(fileName: "locations")
        
        localData.makeConnection { dataResult in
            switch dataResult {
                case .Success(let data):
                    self.citysDictionary = CitysDictionary(json: data)
                    self.states = (self.citysDictionary?.getStates())!
                    self.setCitys()
                case .Failure(let error):
                    print(error)
            }
        }
    }
    
    func setCitys() {
        guard let city = headers[0].slectedItem else {return}
        citys = citysDictionary!.getCitys(in: city)
        self.updateDatasorce()
    }
    
    func setItemInHeader(whit index: Int, slected: String) {
        headers[index].isSectionActive = false
        headers[index].slectedItem = slected
    }
    
    func setSectionby(index: IndexPath) -> GasPriceLocation?{
        let section = index.section
        let selectedItem = (filterQuery != nil) ? (filter?[index.item])! : (section > 0) ?  citys[index.item] : states[index.item]
        setItemInHeader(whit:section, slected: selectedItem)
        
        if section+1 < headers.count {
            headers[section + 1].isSectionActive = true
            headers[section + 1].slectedItem = nil
        }
        getData()
        
        guard let state = headers[0].slectedItem, let city = headers[1].slectedItem else { return nil }
        return GasPriceLocation(state: state, city: city)
    }
    
    func sectiosAreActive() -> Bool {
        return headers[0].isSectionActive || headers[1].isSectionActive
    }
    
    func getActualLocation() -> GasPriceLocation? {
        guard let state = headers[0].slectedItem, let city = headers[1].slectedItem else {
            return nil
        }
        return GasPriceLocation(state: state, city: city)
    }

    
}
