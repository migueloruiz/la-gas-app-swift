//
//  UIPageControl+Custome.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class UICustomePager: UIPageControl {
    
    init(){
        super.init()
        setStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyle()
    }
    
    func setStyle() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.pageIndicatorTintColor = .gray
        self.currentPageIndicatorTintColor = .orange
        self.backgroundColor = .clear
    }
    
}


