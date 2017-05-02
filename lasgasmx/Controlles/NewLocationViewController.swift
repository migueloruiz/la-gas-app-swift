//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController{
    
    var gasPrice : GasPriceInState? = nil
    var selectCityController: SelectCityCollectionController? = nil
    var selectCityDatasource = SelectCityDatasorce()
    
    let storageManager = GasPriceStorageManager()
    lazy var userDeafults: UserDefaultsManager = {
        let configManager = (UIApplication.shared.delegate as! AppDelegate).configManager
        return UserDefaultsManager(suitName: configManager["GROUP_KEY"])!
    }()
    
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
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        return cv
    }()
    
    lazy var deleteButton : UIRoundedButton = {
        let b = UIRoundedButton(withTarget: self, action: #selector(NewLocationViewController.deleteLocation), radius: 10)
        b.backgroundColor = .delete
        b.setTitle("Eliminar locacion", for: .normal)
        return b
    }()
    
    lazy var saveButton : UIRoundedButton = {
        let b = UIRoundedButton(withTarget: self, action: #selector(NewLocationViewController.saveLocation), radius: 10)
        b.backgroundColor = .succes
        b.setTitle("Guardar Locacion", for: .normal)
        return b
    }()
    
    init() { super.init(nibName: nil, bundle: nil) }
    
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
        
        let exitButton = UIBackButton(withTarget: self, action: #selector(NewLocationViewController.popView), type: .cross)
        exitButton.frame = CGRect(x:0 , y:0, width: 20, height: 20)
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
    
    func popToRoot(){
        self.navigationItem.titleView = nil
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popView(){
        self.navigationItem.titleView = nil
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func deleteLocation() {
        guard let price = gasPrice else { return }
        storageManager.deleteWith(id: price.id!)
        userDeafults.delateGasPrices(id: price.id!)
        popToRoot()
    }
    
    func saveLocation() {
        guard let newLocation = selectCityDatasource.getActualLocation()  else { return }
        
        if(!deleteButtonisAvilable) {
            let id = storageManager.newGasPrice(location: newLocation)
            userDeafults.saveNewGasPrices(location: newLocation, id: id)
        } else {
            guard let idToFind = gasPrice?.id  else { return }
            storageManager.updatePriceBy(id: idToFind, recordChanges: { gasPriceToUpdate in
                gasPriceToUpdate.state = newLocation.state
                gasPriceToUpdate.city = newLocation.city
            })
            userDeafults.editGasPrices(location: newLocation, id: idToFind)
        }
        popToRoot()
    }
    
    func setHiddenButtons(_ value: Bool) {
        if (deleteButtonisAvilable) {
            deleteButton.isHidden = value
            deleteButton.alpha = value ? 0 : 1
        }
        saveButton.isHidden = value
        saveButton.alpha = value ? 0 : 1
    }
    
    

}

extension NewLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        selectCityDatasource.filterQuery =  (searchString != "") ? searchString : nil
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
