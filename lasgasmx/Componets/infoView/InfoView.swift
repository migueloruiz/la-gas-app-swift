//
//  InfoView.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InfoView: UIView {
    
    override var bounds: CGRect {
        didSet {
//            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:[.topRight, .topLeft],cornerRadii: CGSize(width: 10, height:  10))
//            let maskLayer = CAShapeLayer()
//            maskLayer.path = path.cgPath
//            self.layer.mask = maskLayer
        }
    }
    
    // TODO: Crear capa de Ads
    let adsView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var rootViewController: UIViewController? = nil
    
    init(root: UIViewController?) {
        self.rootViewController = root
        super.init(frame: .zero)
        setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        adsView.adUnitID = "ca-app-pub-2278511226994516/3431553183"
        adsView.rootViewController = rootViewController
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adsView.load(request)
        
        self.addSubview(adsView)
        
        adsView.anchor(top: nil, left: nil, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        adsView.anchorCenterXToSuperview()
    }

}
