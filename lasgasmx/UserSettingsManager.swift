//
//  UserSettingsManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation

class UserSettingsManager: NSObject {
    
    static var userDefaults: UserDefaults {
        let userDefaults = UserDefaults.standard
        return userDefaults
    }
    
    static func saveLastUpdateDate(value: String) {
        userDefaults.set(value, forKey: UserDefaultsKeys.lastUpdateDate.rawValue)
        userDefaults.synchronize()
    }
    
    static func retrieveLastUpdateDate() -> String? {
        return userDefaults.object(forKey: UserDefaultsKeys.lastUpdateDate.rawValue) as? String
    }
}

enum UserDefaultsKeys: String {
    case lastUpdateDate = "com.lagasmx.LastUpdateDate.key"
}
