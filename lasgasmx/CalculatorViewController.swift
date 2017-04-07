//
//  CalculatorViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController{
    
    var price: GasPriceInState {
        didSet{
        }
    }
    
    let amountInput: UITextField = {
        let i = UITextField()
        i.backgroundColor = .white
        i.font = UIFont.systemFont(ofSize: 24)
        i.translatesAutoresizingMaskIntoConstraints = true
        i.textAlignment = .right
        i.layer.cornerRadius = 10
        i.text = "0.00"
        i.keyboardType = UIKeyboardType.decimalPad
        i.becomeFirstResponder()
        
        return i
    }()
//    class TextField: UITextField {
//        
//        let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
//        
//        override func textRectForBounds(bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//        
//        override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//        
//        override func editingRectForBounds(bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//    }
    
    
    let typeSegment : UISegmentedControl = {
        let items = ["Pesos","Litros"]
        let s = UISegmentedControl(items: items)
        s.selectedSegmentIndex = 0
        s.tintColor = .white
        s.translatesAutoresizingMaskIntoConstraints = true
        return s
    }()
    
    let calcResultsView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = true

        return cv
    }()
    
    init(gasPrice: GasPriceInState) {
        self.price = gasPrice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        view.backgroundColor = .red
        
        let backButton = CrossBackButton(withTarget: self, action: #selector(CalculatorViewController.popView), type: .back)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem  = backButtonItem
        
        let editButton = CrossBackButton(withTarget: self, action: #selector(CalculatorViewController.openEdit), type: .edit)
        let editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem  = editButtonItem
        
        self.navigationItem.set(title: price.getText(), subtitle: price.date)
        
        setSubviews()
    }
    
    func setSubviews() {
        view.addSubview(amountInput)
        view.addSubview(typeSegment)
        view.addSubview(calcResultsView)
        
        amountInput.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: typeSegment.leftAnchor, topConstant: 70, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 40)
        
        typeSegment.anchor(top: amountInput.topAnchor, left: amountInput.rightAnchor, bottom: nil, right: view.rightAnchor, topConstant: 5, leftConstant: 10, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 30)
        
        calcResultsView.anchor(top: amountInput.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

    }
    
    // TODO: creo que aui se puede elimiar el pop view pasandolo a la clase del boton
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func openEdit(){
        guard let nav = self.navigationController else { return }
        nav.pushViewController(NewLocationViewController(gasPrice: price) , animated: true)
    }
    
}

