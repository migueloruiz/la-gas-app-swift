//
//  CalcResultCell.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/7/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class CalcResultCell: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? CalcPrice else {
                return
            }
            
            setColor(by: item.price.type)
            resultLable.text = item.calculate()
        }
    }
    
    let fuelLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.systemFont(ofSize: 18, weight: 500)
        l.textAlignment = .center
        l.textColor = .white
        l.backgroundColor = .clear
        return l
    }()
    
    let resultLable: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = ""
        l.font = UIFont.systemFont(ofSize: 18)
        l.textAlignment = .center
        l.tintColor = .black
        l.backgroundColor = .white
        l.layer.cornerRadius = 20
        l.clipsToBounds = true
        return l
    }()
    
    override func setupViews() {
        addSubview(fuelLabel)
        addSubview(resultLable)
        
        fuelLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: resultLable.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        resultLable.anchor(top: topAnchor, left: fuelLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 5, rightConstant: 15, widthConstant: frame.width * 0.6, heightConstant: 0)
        
    }
    
    // TODO esto se puede volver una funcion mas general
    func setColor( by type: FuelType) {
        fuelLabel.text = type.rawValue
        switch type {
        case .Magna:
            self.backgroundColor = UIColor.magna
        case .Premium:
            self.backgroundColor = UIColor.premium
        case .Diesel:
            self.backgroundColor = UIColor.diesel
        }
    }
    
}
