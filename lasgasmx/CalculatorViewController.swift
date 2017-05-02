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
        
        view.backgroundColor = .white
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = .diesel
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .diesel
        self.navigationController?.navigationBar.tintColor = .diesel
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.diesel]
        self.navigationController?.navigationBar.hiddeShadow()
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        let backButton = UIBackButton(withTarget: self, action: #selector(CalculatorViewController.popView), type: .back)
        backButton.frame = CGRect(x:0 , y:0, width: 20, height: 20)
        let backButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem  = backButtonItem

        
        let editButton = UIBackButton(withTarget: self, action: #selector(CalculatorViewController.openEdit), type: .edit)
        editButton.frame = CGRect(x:0 , y:0, width: 20, height: 20)
        let editButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem  = editButtonItem
        
        self.navigationItem.set(title: price.getText(), subtitle: price.date)
        
        amountInput.focus()
        amountInput.delegate = self
        
        setSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CalculatorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func setSubviews() {
        view.backgroundColor = .diesel
        
        view.addSubview(amountInput)
        view.addSubview(calcResultsView)
        
        amountInput.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: offset - 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 60)
        
        calcResultsView.anchor(top: amountInput.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: offset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func popView(){ _ = self.navigationController?.popViewController(animated: true) }
    
    func openEdit(){
        guard let nav = self.navigationController else { return }
        nav.pushViewController(NewLocationViewController(gasPrice: price) , animated: true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        calcResultController.keboardHeigth = keyboardFrame.size.height
        calcResultController.datasorseUpdate()
    }
    
}

extension CalculatorViewController: UICalcTextFieldDelegate {
    internal func calcTextField(changeValue: CalcType) {
        calcResultDatasource.calc = changeValue
    }
}
