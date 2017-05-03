//
//  UIToast.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/28/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import Foundation

enum UIToastIcons: String {
    case Wifi = "wifi"
    case Uups = "uups"
}

public class UIToast {
    
    private var overlayView = UIView()
    private var mesageImage = UIImageView()
    private var mesageLable = UITextView()
    private var visible = false
    
    class var shared: UIToast {
        struct Static {
            static let instance: UIToast = UIToast()
        }
        return Static.instance
    }
    
    func show(type: UIToastIcons, message: String, color: UIColor) {
        guard !visible else { return }
        guard let window = UIApplication.shared.keyWindow else { return }
        DispatchQueue.main.async {
            self.overlayView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 50))
            self.overlayView.clipsToBounds = true
            self.overlayView.backgroundColor = color
            
            self.addSubviews (type: type, message: message)

            window.addSubview(self.overlayView)
            self.visible = true
            
            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.center.y = self.overlayView.center.y - 50
            })
        }
    }
    
    public func hide() {
        guard visible else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.center.y = self.overlayView.center.y + 50
            }, completion: { flag in
                self.overlayView.removeFromSuperview()
                self.visible = false
            })
        }
    }
    
    public func isVisible() -> Bool {
        return visible
    }
    
    private func addSubviews (type: UIToastIcons, message: String) {
        mesageImage.image = UIImage(named: type.rawValue)?.withRenderingMode(.alwaysTemplate)
        mesageImage.tintColor = .white
        mesageImage.contentMode = .scaleAspectFit
        
        mesageLable = UITextView()
        mesageLable.text = message
        mesageLable.textColor = .white
        mesageLable.backgroundColor = .clear
        mesageLable.isEditable = false
        mesageLable.isSelectable = false
        mesageLable.font = UIFont.systemFont(ofSize: 12)
        
        
        overlayView.addSubview(mesageImage)
        overlayView.addSubview(mesageLable)
        
        mesageLable.anchor(top: overlayView.topAnchor, left: mesageImage.rightAnchor, bottom: overlayView.bottomAnchor, right: overlayView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        mesageImage.anchor(top: overlayView.topAnchor, left: overlayView.leftAnchor, bottom: overlayView.bottomAnchor, right: mesageLable.leftAnchor, topConstant: 7, leftConstant: 5, bottomConstant: 7, rightConstant: 5, widthConstant: 50, heightConstant: 0)
    }
}

