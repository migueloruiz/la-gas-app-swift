//
//  UIButton+Custome.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/18/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

enum UIMapControlButtonType {
    case navigation
    case controls
}
class UIMapControlButton: UIButton {
    
    init( withTarget target: Any?, action: Selector, radius: CGFloat, type: UIMapControlButtonType ){
        super.init(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.tintColor = .black
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setImage( getImageBy(type).withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getImageBy(_ type: UIMapControlButtonType ) -> UIImage{
        switch type {
        case .controls:
            return #imageLiteral(resourceName: "controls")
        case .navigation:
            return #imageLiteral(resourceName: "navigation")
        }
        
    }
}


class UIRoundedButton: UIButton {
    
    init( withTarget target: Any?, action: Selector, radius: CGFloat ){
        super.init(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.tintColor = .white
        self.addTarget(target, action: action, for: .touchUpInside)
        self.isHidden = true
        self.alpha = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
