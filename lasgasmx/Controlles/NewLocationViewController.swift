//
//  EditLocationViewController.swift
//  lasgasmx
//
//  Created by Miguelo Ruiz on 30/03/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class NewLocationViewController: UIViewController, UISearchResultsUpdating{
    
    var state: String = ""
    var city: String = ""
    
    lazy var searchController: UISearchController = {
        let s = UISearchController(searchResultsController: nil)
        s.searchResultsUpdater = self
        s.dimsBackgroundDuringPresentation = false
//        s.definesPresentationContext = false
        s.hidesNavigationBarDuringPresentation = false
//        s.searchBar.placeholder = "Search here..."
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
        self.navigationController?.isNavigationBarHidden = false
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchController.searchBar)
        self.navigationItem.titleView = searchController.searchBar
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    func setSubviews() {
        view.addSubview(selectCityView)
        
        selectCityView.anchor(top: view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        print("4")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("3")
    }    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
//        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
//        self.navigationController?.isNavigationBarHidden = true
        
    }
}
