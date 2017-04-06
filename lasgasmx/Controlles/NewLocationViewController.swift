//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController, UISearchResultsUpdating{
    
    var location : GasPriceLocation? = nil
    var selectCityController: SelectCityCollectionController? = nil
    var selectCityDatasource = SelectCityDatasorce()
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.dimsBackgroundDuringPresentation = false
        s.hidesNavigationBarDuringPresentation = false
        s.searchBar.placeholder = "Buscar..."
        return s
    }()
    
    lazy var selectCityView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(location: GasPriceLocation) {
        super.init(nibName: nil, bundle: nil)
        self.location = location
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setSubviews()
        
        if location != nil {
            selectCityDatasource = SelectCityDatasorce(location: location!)
        }
        
        selectCityController = SelectCityCollectionController(collectionView: selectCityView, datasorce: selectCityDatasource)
        selectCityController?.delegate = self
        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.titleView = searchController.searchBar
        
        let myBackButton:UIButton = UIButton()
        let crossImage = UIImage(named: "cross")
        myBackButton.addTarget(self, action: #selector(NewLocationViewController.popToRoot), for: .touchUpInside)
        myBackButton.setImage(crossImage, for: .normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func setSubviews() {
        view.addSubview(selectCityView)
        selectCityView.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        selectCityDatasource.filterQuery =  (searchController.isActive && searchString != "") ? searchString : nil
    }    
    
    func popToRoot(){
        self.navigationController?.popViewController(animated: true)
    }

}

extension NewLocationViewController: SelectCityCollectionDelegate{
    
    func itemsSelected(location: GasPriceLocation?) {
        searchController.searchBar.text = ""
        searchController.searchBar.endEditing(true)
        
        print(selectCityDatasource.sectiosAreActive())
        // activar y desactivar botones
        
        guard let l = location else { return }
        print("\(l)")
        
        // Create new GasPrice in CoreData
    }
    
}
