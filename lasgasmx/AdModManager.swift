//
//  AdModManager.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import Foundation
import Firebase

class AdModManager {
    internal let privateKey: String
    
    init(key: String) {
        self.privateKey = key
        GADMobileAds.configure(withApplicationID: "ca-app-pub-\(self.privateKey)")
    }
    
    func getBanner( with adUnitID: String ) -> GADBannerView {
        let banner = GADBannerView()
        banner.adUnitID = "ca-app-pub-\(self.privateKey)/3431553183"
        return banner
    }
    
    func getTestRequest() -> GADRequest {
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        return request
    }

}
