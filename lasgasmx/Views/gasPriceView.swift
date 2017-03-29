//
//  gasPriceView.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/28/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class gasPriceView: UIView {
    
    let cityLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Miguel Hidalgo, Ciudad de México"
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .center
        return lable
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        
        let view1 = gasItem( withType: .Magna )
        let view2 = gasItem( withType: .Premium )
        let view3 = gasItem( withType: .Diesel)
        
        view1.price = 16.89
        view2.price = 16.90
        view3.price = 19.89
        
        let pricesStack = UIStackView(arrangedSubviews: [
            view1,
            view2,
            view3
            ])
        pricesStack.axis = .horizontal
        pricesStack.distribution = .fillEqually
        pricesStack.translatesAutoresizingMaskIntoConstraints = false


        self.addSubview(cityLable)
        self.addSubview(pricesStack)
        
        cityLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        cityLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        cityLable.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        cityLable.heightAnchor.constraint(equalToConstant: 23).isActive = true
        
        pricesStack.topAnchor.constraint(equalTo: cityLable.bottomAnchor, constant: 0).isActive = true
        pricesStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        pricesStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        pricesStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }

}

class gasItem: UIView {
    
    var price: Float {
        set(new) { priceLabel.text = "\(new) $" }
        get { return self.price }
    }
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fuelTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init( withType fule: FuelType ) {
        self.init(frame: CGRect.zero)
        setupView()
        setColor(by: fule)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(priceLabel)
        addSubview(fuelTypeLabel)
        
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 3).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        fuelTypeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -5).isActive = true
        fuelTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        fuelTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        fuelTypeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3).isActive = true
    }
    
    func setColor( by type: FuelType) {
        fuelTypeLabel.text = type.rawValue
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


enum FuelType: String {
    case Magna = "Magana"
    case Premium = "Premium"
    case Diesel = "Diesel"
}











