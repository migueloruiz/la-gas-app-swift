//
//  CalculatorViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/6/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    var price: GasPriceInState
    var calcResultController: CalcResultsCollectionController
    var calcResultDatasource: CalcResultDatasorce
    
    let offset: CGFloat = 30;
    
    let amountInput = UICalcTextField()
    
    let calcResultsView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = true

        return cv
    }()
    
    init(gasPrice: GasPriceInState) {
        self.price = gasPrice
        calcResultDatasource = CalcResultDatasorce(prices: gasPrice.prices)
        calcResultController = CalcResultsCollectionController(collectionView: calcResultsView, datasorce: calcResultDatasource)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        
        let backButton = UIBackButton(withTarget: self, action: #selector(CalculatorViewController.popView), type: .back)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem  = backButtonItem
        
        let editButton = UIBackButton(withTarget: self, action: #selector(CalculatorViewController.openEdit), type: .edit)
        let editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem  = editButtonItem
        
        self.navigationItem.set(title: price.getText(), subtitle: price.date)
        
        amountInput.focus()
        amountInput.delegate = self
        
        setSubviews()
    }
    
    func setSubviews() {
        view.addSubview(amountInput)
        view.addSubview(calcResultsView)
        
        amountInput.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 60 + offset, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 40)
        
        calcResultsView.anchor(top: amountInput.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: offset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
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

extension CalculatorViewController: UICalcTextFieldDelegate {
    internal func calcTextField(changeValue: CalcType) {
        calcResultDatasource.calc = changeValue
    }
}
