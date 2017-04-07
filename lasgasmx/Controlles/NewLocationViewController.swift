//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController, UISearchResultsUpdating{
    
    var gasPrice : GasPriceInState? = nil
    var selectCityController: SelectCityCollectionController? = nil
    var selectCityDatasource = SelectCityDatasorce()
    
    let storageManager = GasPriceStorageManager()
    
    var deleteButtonisAvilable = false
    var saveButtonisAvilable = true
    
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
    
    let deleteButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 10
        b.backgroundColor = .delete
        b.setTitle("Eliminar locacion", for: .normal)
        b.addTarget(self, action: #selector(NewLocationViewController.deleteLocation), for: .touchUpInside)
        b.isHidden = true
        b.alpha = 0
        return b
    }()
    
    let saveButton : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 10
        b.backgroundColor = .succes
        b.setTitle("Guardar Locacion", for: .normal)
        b.addTarget(self, action: #selector(NewLocationViewController.saveLocation), for: .touchUpInside)
        b.isHidden = true
        b.alpha = 0
        return b
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(gasPrice: GasPriceInState) {
        super.init(nibName: nil, bundle: nil)
        self.gasPrice = gasPrice
        deleteButtonisAvilable = true
        saveButtonisAvilable = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setSubviews()
        
        if let price = gasPrice {
            selectCityDatasource = SelectCityDatasorce(location: price.priceLocation)
        }
        
        selectCityController = SelectCityCollectionController(collectionView: selectCityView, datasorce: selectCityDatasource)
        selectCityController?.delegate = self
        self.navigationController?.isNavigationBarHidden = false

        self.navigationItem.titleView = searchController.searchBar
        
        let exitButton = CrossBackButton(withTarget: self, action: #selector(NewLocationViewController.popView), type: .cross)
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: exitButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    func setSubviews() {
        view.addSubview(selectCityView)
        view.addSubview(deleteButton)
        view.addSubview(saveButton)
        
        setHiddenButtons(saveButtonisAvilable)
        
        selectCityView.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        deleteButton.anchor(top: nil, left: view.leftAnchor, bottom: saveButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 20, heightConstant: 40)
        
        saveButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 20, rightConstant: 30, widthConstant: 20, heightConstant: 40)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        selectCityDatasource.filterQuery =  (searchController.isActive && searchString != "") ? searchString : nil
    }    
    
    func popToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteLocation() {
        guard let price = gasPrice else { return }
        storageManager.deleteWith(id: price.id!)
        popToRoot()
    }
    
    func saveLocation() {
        if(!deleteButtonisAvilable) {
            guard let newLocation = selectCityDatasource.getActualLocation() else {
                print("manejar error")
                return
            }
            storageManager.newGasPrice(location: newLocation)
            popToRoot()
        } else {
            print("Editar viejo")
        }
    }
    
    func setHiddenButtons(_ value: Bool) {
        if (deleteButtonisAvilable){
            deleteButton.isHidden = value
            deleteButton.alpha = value ? 0 : 1
        }
        saveButton.isHidden = value
        saveButton.alpha = value ? 0 : 1
    }

}

extension NewLocationViewController: SelectCityCollectionDelegate{
    
    func itemsSelected(location: GasPriceLocation?) {
        searchController.searchBar.text = ""
        searchController.searchBar.endEditing(true)
        
        setHiddenButtons(selectCityDatasource.sectiosAreActive())
    }
    
    func headerTapped() {
        setHiddenButtons(selectCityDatasource.sectiosAreActive())
    }
    
}
