//
//  UIColor+Helper.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/28/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(r: r, g: g, b: b, a: 1)
    }
    
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
}

// MARK - APP Colors

extension UIColor {
    static var magna: UIColor  { return UIColor(r: 247, g: 63, b: 46) }
    static var premium: UIColor  { return UIColor(r: 24, g: 176, b: 106) }
    static var diesel: UIColor  { return UIColor(r: 76, g: 76, b: 76) }
    
    static var delete: UIColor  { return UIColor(r: 247, g: 109, b: 59) }
    static var succes: UIColor  { return UIColor(r: 0, g: 240, b: 135) }
}
