//
//  InfoView.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    var rootViewController: UIViewController? = nil
    let margin : CGFloat = 20
    
    private var viewHeights: [String :CGFloat] = [:]
    
    var estimatedHeight: CGFloat = 350
    
    var gasStation: GasStation? = nil {
        didSet{
            guard let station = gasStation else { return }
            stationNameLable.text = station.name.capitalized
            pricesStack.clearSubviews()
            for price in station.prices {
                let priceView = GasItemView(price: price.price, forType: price.type)
                pricesStack.addArrangedSubview(priceView)
            }
            
            guard let route = station.route else {
                timeLable.text = ""
                distanceLable.text = ""
                directionArea.text = ""
                return
            }
            timeLable.text = "A \(route.time) aprox."
            distanceLable.text = "A \(route.distance) aprox."
            directionArea.text = route.address
            
            estimatedHeight = estimateHeight(text: route.address)
        }
    }
    
    let stationNameLable: UILabel = {
        let l = UILabel()
        l.backgroundColor = .softBlue
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    let timeLable: UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    let distanceLable: UILabel = {
        let l = UILabel()
        l.textAlignment = .right
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()
    
    let locationIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "genericLocationIcon")
        iv.contentMode = UIViewContentMode.scaleAspectFit
        return iv
    }()
    
    let directionArea: UITextView = {
        let t = UITextView()
        t.font = UIFont.systemFont(ofSize: 14)
        t.isEditable = false
        t.isSelectable = true
        t.isScrollEnabled = false
        t.backgroundColor = .clear
        return t
    }()
    
    let pricesStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [])
        s.axis = .horizontal
        s.distribution = .fillEqually
        return s
    }()
    
    let stackViewContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        return v
    }()
    
    lazy var directionsButton : UIRoundedButton = {
        let b = UIRoundedButton(withTarget: self, action: #selector(InfoView.showDirectionsOptions), radius: 10)
        b.backgroundColor = .softBlue
        b.setTitle("Como llegar", for: .normal)
        b.alpha = 1
        b.isHidden = false
        return b
    }()
    
    init(root: UIViewController?) {
        self.rootViewController = root
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        let magna = GasItemView(price: 16.50, forType: .Magna)
        pricesStack.addArrangedSubview(magna)
        let premium = GasItemView(price: 16.50, forType: .Premium)
        pricesStack.addArrangedSubview(premium)
        let diesel = GasItemView(price: 16.50, forType: .Diesel)
        pricesStack.addArrangedSubview(diesel)
        
        stackViewContainer.addSubview(pricesStack)
        pricesStack.fillSuperview()
        
        self.addSubview(stationNameLable)
        self.addSubview(timeLable)
        self.addSubview(distanceLable)
        self.addSubview(directionArea)
        self.addSubview(locationIcon)
        self.addSubview(stackViewContainer)
        self.addSubview(directionsButton)
        
        viewHeights["stationNameLable"] = 50
        stationNameLable.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: viewHeights["stationNameLable"]!)
        
        viewHeights["subLabelsHeigth"] = 20
        timeLable.anchor(top: stationNameLable.bottomAnchor, left: stationNameLable.leftAnchor, bottom: nil
            , right: nil, topConstant: 0, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: viewHeights["subLabelsHeigth"]!)
        distanceLable.anchor(top: stationNameLable.bottomAnchor, left: nil, bottom: nil
            , right: stationNameLable.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: viewHeights["subLabelsHeigth"]!)
        
        viewHeights["directionTopOffset"] = -3
        directionArea.anchor(top: distanceLable.bottomAnchor, left: locationIcon.rightAnchor, bottom: nil
            , right: distanceLable.rightAnchor, topConstant: viewHeights["directionTopOffset"]!, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        locationIcon.anchor(top: directionArea.topAnchor, left: timeLable.leftAnchor, bottom: directionArea.bottomAnchor, right: directionArea.leftAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 30, heightConstant: 0)
        
        viewHeights["stackViewTopoffset"] = 0
        viewHeights["stackViewHeigth"] = 40
        stackViewContainer.anchor(top: directionArea.bottomAnchor, left: timeLable.leftAnchor, bottom: nil, right: distanceLable.rightAnchor, topConstant: viewHeights["stackViewTopoffset"]!, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: viewHeights["stackViewHeigth"]!)
        
        viewHeights["directionsButtonTopoffset"] = 15
        viewHeights["directionsButtonHeigth"] = 40
        directionsButton.anchor(top: stackViewContainer.bottomAnchor, left: timeLable.leftAnchor, bottom: nil, right: distanceLable.rightAnchor, topConstant: viewHeights["directionsButtonTopoffset"]!, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: viewHeights["directionsButtonHeigth"]!)
        
        viewHeights["BottomMargion"] = 10
    }
    
    public func estimateHeight(text: String) -> CGFloat {
        var heigth: CGFloat = 0
        
        for (_ ,item) in viewHeights {
            heigth = heigth + item
        }
        
        let size = CGSize(width: directionArea.bounds.width, height: 1000)
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
        ]
        let textAreaVerticalMargin: CGFloat = 14 // directionArea.contentInset.top + directionArea.contentInset.bottom
        let textRect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let totalHeigth = textRect.height + textAreaVerticalMargin
        
        let locationIconHeigth: CGFloat = 66.5 // alto d ela imagen a con ancho de 30
        
        
        return heigth + ((totalHeigth > locationIconHeigth) ? totalHeigth : locationIconHeigth)
    }

}
