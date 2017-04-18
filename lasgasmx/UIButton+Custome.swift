//
//  UIButton+Custome.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/18/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class UICenterUser: UIButton {
    
    init( withTarget target: Any?, action: Selector, radius: CGFloat ){
        super.init(frame: CGRect(x: 0, y: 0, width: radius, height: radius))
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.backgroundColor = .white
        self.tintColor = .black
        self.addTarget(target, action: action, for: .touchUpInside)
        self.setImage( #imageLiteral(resourceName: "navigation").withRenderingMode(.alwaysTemplate), for: .normal)
        self.imageEdgeInsets = UIEdgeInsetsMake(10, 4, 7, 7)
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
