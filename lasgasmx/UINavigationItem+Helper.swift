//
//  UINavigationItem+Helper.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

extension UINavigationItem {
    
    func set(title:String, subtitle:String) {
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel()
        subtitleLabel.backgroundColor = .clear
        subtitleLabel.textColor = .black
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        titleLabel.anchor(top: titleView.topAnchor, left: titleView.leftAnchor, bottom: subtitleLabel.topAnchor, right: titleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0 )
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor, left: titleView.leftAnchor, bottom: titleView.bottomAnchor, right: titleView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0 )
        
        
        self.titleView = titleView
    }
}
