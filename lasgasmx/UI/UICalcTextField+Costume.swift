//
//  UITextField+Costume.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/7/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

protocol UICalcTextFieldDelegate {
    func calcTextField( changeValue: CalcType )
}

class UICalcTextField: UIView {
    
    let butonsWidth: CGFloat = 36
    var delegate: UICalcTextFieldDelegate? = nil
    
    lazy var moneyButton: UICalcButton = {
        return UICalcButton(withTarget: self, action: #selector(UICalcTextField.changeInputMode) , type: .dollar )
    }()
    lazy var litersButton: UICalcButton = {
        return UICalcButton(withTarget: self, action: #selector(UICalcTextField.changeInputMode) , type: .liter )
    }()
    
    let textField : UITextField = {
        let t = UITextField()
        t.backgroundColor = .clear
        t.font = UIFont.systemFont(ofSize: 24)
        t.translatesAutoresizingMaskIntoConstraints = true
        t.textAlignment = .right
        t.placeholder = "0.0"
        t.keyboardType = UIKeyboardType.decimalPad
        return t
    }()
    
    var inputMode = true {
        didSet{
            moneyButton.isActive = inputMode
            litersButton.isActive = !inputMode
            textField.textAlignment = inputMode ? NSTextAlignment.left : NSTextAlignment.right
        }
    }
    
    init(){
        super.init(frame: .zero)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(UICalcTextField.textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
        styleView()
    }
    
    func styleView() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundColor = .red
        self.layer.cornerRadius = 20
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.lightGray.cgColor
        self.inputMode = true
        
        self.addSubview(textField)
        self.addSubview(moneyButton)
        self.addSubview(litersButton)
        
        textField.anchor(top: topAnchor, left: moneyButton.rightAnchor, bottom: bottomAnchor, right: litersButton.leftAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        moneyButton.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 2, leftConstant: 2, bottomConstant: 2, rightConstant: 0, widthConstant: butonsWidth, heightConstant: 0)
        
        litersButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 2, rightConstant: 2, widthConstant: butonsWidth, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func focus() {
        textField.becomeFirstResponder()
    }
    
    @objc func changeInputMode() {
        inputMode = !inputMode
        guard let d = delegate else { return }
        d.calcTextField( changeValue: getCalcType() )
    }
    
    func textFieldDidChange(sender : NSNotification) {
        guard let d = delegate, sender.object as! UITextField == self.textField else { return }
        d.calcTextField( changeValue: getCalcType() )
    }
    
    func getCalcType() -> CalcType {
        let value = Float(self.textField.text ?? "0") ?? 0
        return (inputMode) ? CalcType.liters(value) : CalcType.pesos(value)
    }
    
//    private let padding = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 45)
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }

}

enum UICalcButtonType {
    case dollar
    case liter
}

class UICalcButton: UIButton {
    
    var isActive: Bool = true {
        didSet{
            if isActive {
                self.backgroundColor = .black
            } else {
                self.backgroundColor = .lightGray
            }
        }
    }
    
    init( withTarget target: Any?, action: Selector, type: UICalcButtonType ){
        super.init(frame: .zero)
       
        self.addTarget(target, action: action, for: .touchUpInside)
        
        self.setImage( getImageBy(type).withRenderingMode(.alwaysTemplate), for: .normal)
        self.sizeToFit()
        
        self.backgroundColor = .clear
        self.tintColor = .white
        self.layer.cornerRadius = 20
        self.translatesAutoresizingMaskIntoConstraints = true
        
        self.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)

        self.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getImageBy(_ type: UICalcButtonType ) -> UIImage{
        switch type {
        case .dollar:
            return #imageLiteral(resourceName: "dollar")
        case .liter:
            return #imageLiteral(resourceName: "drop")
        }
    }
}
