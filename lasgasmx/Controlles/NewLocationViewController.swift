//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController {
    
    var state: String = ""
    var city: String = ""
    
    let cancelButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = true
        b.backgroundColor = .red
        return b
    }()
    
    let serchBar: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        return s
    }()
    
    lazy var selectCityView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var selctCityController: SelectCityCollectionController? = nil
    let selectCityDatasource = SelectCityDatasorce()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(state: String, city: String) {
        super.init(nibName: nil, bundle: nil)
        self.state = state
        self.city = city
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSubviews()
        
        selctCityController = SelectCityCollectionController(collectionView: selectCityView, datasorce: selectCityDatasource)
        
    }
    
    func setSubviews() {
        view.addSubview(cancelButton)
        view.addSubview(selectCityView)
        
        cancelButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        cancelButton.addTarget(self, action: #selector(NewLocationViewController.dismissView), for: .touchUpInside )
        
        selectCityView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height * 0.9)
    }
    
    func dismissView() {
        print("close")
        guard let nav = self.navigationController else {
            print("NavigationController not abilable")
            return
        }
        nav.popViewController(animated: true)
    }

}
