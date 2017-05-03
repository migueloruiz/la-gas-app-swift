//
//  UserDefaultsManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case Index = "com.lagasmx.satateLocationsINDEX.key"
    case FirstLaunch = "com.lagasmx.FirstLaunch.key"
}

class UserDefaultsManager {
    
    private let userDefaults: UserDefaults
    
    init() {
        self.userDefaults = UserDefaults.standard
    }
    
    init?(suitName: String) {
        guard let ud = UserDefaults.init(suiteName: suitName) else { fatalError("\(suitName) error") }
        self.userDefaults = ud
        self.userDefaults.synchronize()
    }
    
    func isFistLaunch() -> Bool? {
        return userDefaults.object(forKey: UserDefaultsKeys.FirstLaunch.rawValue) as? Bool
    }
    
    func retrieveIndexs() -> UserDefaultPricesID {
        guard let indexEncode = userDefaults.object(forKey: UserDefaultsKeys.Index.rawValue) as? String else {
            return UserDefaultPricesID()
        }
        return UserDefaultPricesID(decode: indexEncode)
    }
    
    func retrieveLocations() -> [GasPriceLocation] {
        let index = retrieveIndexs()
        guard index.count() > 0 else { return [] }
        
        return index.getArray().map({id in
            let encode = userDefaults.object(forKey: id) as? String
            return GasPriceLocation(decode: encode!)!
        })
    }
    
    func saveNewGasPrices(location: GasPriceLocation, id: String) {
        var index = retrieveIndexs()
        
        index.add(id: id)
        let encideIndex = index.encode()
        userDefaults.set(encideIndex, forKey: UserDefaultsKeys.Index.rawValue)
        
        let encode = location.encode()
        userDefaults.set(encode, forKey: id)
        userDefaults.synchronize()
    }
    
    func delateGasPrices(id: String) {
        var index = retrieveIndexs()
        guard index.hasId(id: id) else { return }
        
        index.delete(id: id)
        let encideIndex = index.encode()
        userDefaults.set(encideIndex, forKey: UserDefaultsKeys.Index.rawValue)
        userDefaults.removeObject(forKey: id)
        userDefaults.synchronize()
    }
    
    func editGasPrices(location: GasPriceLocation, id: String) {
        let index = retrieveIndexs()
        guard index.hasId(id: id) else { return }

        let encode = location.encode()
        userDefaults.set(encode, forKey: id)

        userDefaults.synchronize()
    }
}
