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
//        view.addSubview(selectCityView)

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

