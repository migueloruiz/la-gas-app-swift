//
//  UIItemButton+Custome.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

enum UIBackButtonType {
    case cross
    case back
    case edit
}

class UIBackButton: UIButton {

    init( withTarget target: Any?, action: Selector, type: UIBackButtonType ){
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setImage( getImageBy(type), for: .normal)
        self.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getImageBy(_ type: UIBackButtonType ) -> UIImage{
        switch type {
            case .cross:
                return #imageLiteral(resourceName: "cross")
            case .back:
                return #imageLiteral(resourceName: "back")
            case .edit:
                return #imageLiteral(resourceName: "edit")
        }
    
    }
}


