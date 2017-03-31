//
//  UIStackView+Helpers.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

extension UIStackView {
    public func clearSubviews() {
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
