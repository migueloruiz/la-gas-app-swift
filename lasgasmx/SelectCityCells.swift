//
//  SelectCityCells.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/31/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//
import UIKit

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
        v.backgroundColor = .diesel
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

class SelectCityHeader: CollectionDatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let item = datasourceItem as? SelectCityHeadersItems else { return }
            label.text = item.getText()
            arrowImage.image = getImage(item : item)
        }
    }
    
    let label :UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.backgroundColor = .clear
        return l
    }()
    
    let arrowImage: UIImageView = {
        let i = UIImageView()
        i.contentMode = UIViewContentMode.scaleAspectFit
        i.tintColor = .white
        return i
    }()
    
    override func setupViews() {
        super.setupViews()
        self.backgroundColor = .diesel
        addSubview(label)
        addSubview(arrowImage)
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: arrowImage.leftAnchor, topConstant: 0, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        arrowImage.anchor(top: topAnchor, left: label.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 15, widthConstant: 15, heightConstant: 0)
    }
    
    internal func getImage(item : SelectCityHeadersItems) -> UIImage {
        let image = (item.isSectionActive) ? #imageLiteral(resourceName: "up-arrow") : #imageLiteral(resourceName: "down-arrow")
        return image.withRenderingMode(.alwaysTemplate)
    }
}
