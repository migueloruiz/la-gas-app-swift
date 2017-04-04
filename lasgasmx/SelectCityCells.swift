//
//  SelectCityCells.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/31/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit

// TODO: Elemento preseccionado

class SelectCityCell: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            if let text = datasourceItem as? String {
                label.text = text.capitalized
            } else {
                label.text = datasourceItem.debugDescription
            }
        }
    }
    
    let label :UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = true
        l.font = UIFont.systemFont(ofSize: 14)
        l.backgroundColor = .clear
        return l
    }()
    
    let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        v.translatesAutoresizingMaskIntoConstraints = true
        return v
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(label)
        addSubview(separatorView)
        
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        let leftSeparation: CGFloat = 20
        separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: leftSeparation, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width - leftSeparation, heightConstant: 1)
    }
    
}

// TODO: arrow up y down

class SelectCityHeader: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? SelectCityHeadersItems else {
                return
            }
            label.text = "  \(item.getText())"
        }
    }
    
    let label :UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = true
        l.textColor = .white
        l.backgroundColor = .gray
        return l
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(label)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
}
