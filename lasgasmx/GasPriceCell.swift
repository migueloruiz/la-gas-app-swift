//
//  GasPriceCell.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/30/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class GasPriceCell: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? GasPriceInState else {
                return
            }
            cityLable.text = item.getText()
            dateLable.text = item.date
            
            pricesStack.clearSubviews()
            
            for price in item.prices {
                let priceView = GasItemView(price: price.price, forType: price.type)
                pricesStack.addArrangedSubview(priceView)
            }
        }
    }
    
    let pricesStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [])
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let cityLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textAlignment = .center
        return lable
    }()
    
    let dateLable: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.textAlignment = .center
        return lable
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(cityLable)
        self.addSubview(dateLable)
        self.addSubview(pricesStack)
        
        cityLable.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 22)
        
        dateLable.anchor(top: cityLable.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: -4, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 18)
        
        pricesStack.anchor(top: dateLable.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }

}

class GasPriceEmptyCell: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {}
    }
    
    let textLable: UITextView = {
        let lable = UITextView()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Agrega hasta 5 locaciones para consultar los precios"
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.textAlignment = .left
        lable.isEditable = false
        lable.isSelectable = false
        lable.isUserInteractionEnabled = false
        return lable
    }()
    
    let addbutton : UIButton = {
        let b = UIButton(type: .contactAdd)
        b.isUserInteractionEnabled = false
        return b
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(textLable)
        self.addSubview(addbutton)
        
        textLable.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: addbutton.leftAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 0, rightConstant: 0, widthConstant: self.frame.width * 0.8, heightConstant: 0)

        addbutton.anchor(top: self.topAnchor, left: textLable.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: self.frame.width * 0.2, heightConstant: 0)
    }
    
}


class GasItemView: UIView {
    
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
    
    let fuelTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
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
        addSubview(fuelTypeLabel)
        
        priceLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 3, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        priceLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        
        fuelTypeLabel.anchor(top: priceLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: -5, leftConstant: 0, bottomConstant: 3, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    // TODO esto se puede volver una funcion mas general
    
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


