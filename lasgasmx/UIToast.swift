//
//  UIToast.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/28/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import Foundation

public class UIToast {
    
    private var overlayView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    private var visible = false {
        didSet{
            UIApplication.shared.isNetworkActivityIndicatorVisible = visible
        }
    }
    
    var count = 0
    
    class var shared: UILoadingIndicator {
        struct Static {
            static let instance: UILoadingIndicator = UILoadingIndicator()
        }
        return Static.instance
    }
    
    public func show() {
        guard !visible else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        DispatchQueue.main.async {
            self.overlayView = UIView(frame: UIScreen.main.bounds)
            self.overlayView.clipsToBounds = true
            self.overlayView.center = window.center
            self.overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            self.overlayView.addSubview(self.activityIndicator)
            self.activityIndicator.fillSuperview()
            self.activityIndicator.startAnimating()
            window.addSubview(self.overlayView)
            self.visible = true
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.overlayView.removeFromSuperview()
            self.visible = false
        }
    }
    
    public func isVisible() -> Bool {
        return visible
    }
}

