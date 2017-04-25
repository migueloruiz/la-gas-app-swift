//
//  GasStationsMapViews.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/17/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

//class MapMarker: UIView {
//    
//    
//    convenience init(price: Float, forType fule: FuelType ) {
//        self.init(frame: CGRect.zero)
//        setupView()
//        setColor(by: fule)
//        self.price = price
//        priceLabel.text = (price > 0) ? price.asPesos : "- -"
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding")
//    }
//    
//    func setupView() {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(priceLabel)
//        priceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//    }
//    
//    // TODO esto se puede volver una funcion mas general
//    func setColor( by type: FuelType) {
//        switch type {
//        case .Magna:
//            self.backgroundColor = UIColor.magna
//        case .Premium:
//            self.backgroundColor = UIColor.premium
//        case .Diesel:
//            self.backgroundColor = UIColor.diesel
//        }
//    }
//}

class MapMarkerGasItemView: UIView {
    
    var price: Float {
        didSet(newValue) {
            priceLabel.text = (newValue > 0) ? newValue.asPesos : "- -"
        }
    }
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        self.price = 0
        super.init(frame: frame)
        setupView()
    }
    
    convenience init(price: Float, forType fule: FuelType ) {
        self.init(frame: CGRect.zero)
        setupView()
        setColor(by: fule)
        self.price = price
        priceLabel.text = (price > 0) ? price.asPesos : "- -"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addSubview(priceLabel)
        priceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // TODO esto se puede volver una funcion mas general
    func setColor( by type: FuelType) {
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
