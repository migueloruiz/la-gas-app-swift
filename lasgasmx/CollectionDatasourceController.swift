//
//  CollectionViewDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

open class CollectionDatasourceController:NSObject, UICollectionViewDataSource, UICollectionViewDelegate, CollectionDatasourceDelegate, UICollectionViewDelegateFlowLayout {
    
    private unowned var collectionView: UICollectionView
    
    open let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .black
        return aiv
    }()
    
    open var datasource: CollectionDatasource? {
        didSet {
            if let cellClasses = datasource?.cellClasses() {
                for cellClass in cellClasses {
                    let className = String(describing: cellClass)
                    collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: className))
                }
            }

            if let headerClasses = datasource?.headerClasses() {
                for headerClass in headerClasses {
                    collectionView.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier:String(describing: headerClass))
                }
            }
            
            if let footerClasses = datasource?.footerClasses() {
                for footerClass in footerClasses {
                    collectionView.register(footerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: footerClass))
                }
            }
            collectionView.reloadData()
        }
    }
    
    let defaultCellId = "lbta_defaultCellId"
    let defaultFooterId = "lbta_defaultFooterId"
    let defaultHeaderId = "lbta_defaultHeaderId"

    
    init(collectionView: UICollectionView, datasorce: CollectionDatasource) {
        self.collectionView = collectionView
        self.datasource = datasorce
        super.init()
        
        datasorce.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DefaultCell.self, forCellWithReuseIdentifier: defaultCellId)
        collectionView.register(DefaultHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: defaultHeaderId)
        collectionView.register(DefaultFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: defaultFooterId)
        
        if let cellClasses = datasource?.cellClasses() {
            for cellClass in cellClasses {
                collectionView.register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
            }
        }
        
        if let headerClasses = datasource?.headerClasses() {
            for headerClass in headerClasses {
                collectionView.register(headerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier:String(describing: headerClass))
            }
        }
        
        if let footerClasses = datasource?.footerClasses() {
            for footerClass in footerClasses {
                collectionView.register(footerClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: String(describing: footerClass))
            }
        }
        
        setupViews(collectionView: collectionView)
    }
    
    open func setupViews( collectionView: UICollectionView) { }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource?.numberOfSections() ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.numberOfItems(section) ?? 0
    }
    
    //need to override this otherwise size doesn't get called
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: CollectionDatasourceCell
        
        if let cls = datasource?.cellClass(indexPath) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cls), for: indexPath) as! CollectionDatasourceCell
        } else if let cellClasses = datasource?.cellClasses(), cellClasses.count > indexPath.section {
            let cls = cellClasses[indexPath.section]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cls), for: indexPath) as! CollectionDatasourceCell
        } else if let cls = datasource?.cellClasses().first {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: cls), for: indexPath) as! CollectionDatasourceCell
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellId, for: indexPath) as! CollectionDatasourceCell
        }
        
        cell.controller = self
        cell.datasourceItem = datasource?.item(indexPath)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         print("call viewForSupplementaryElementOfKind")
        
        var reusableView: CollectionDatasourceCell
        
        if kind == UICollectionElementKindSectionHeader {
            if let classes = datasource?.headerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: classes[indexPath.section]), for: indexPath) as! CollectionDatasourceCell
            } else if let cls = datasource?.headerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: cls), for: indexPath) as! CollectionDatasourceCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultHeaderId, for: indexPath) as! CollectionDatasourceCell
            }
            reusableView.datasourceItem = datasource?.headerItem(indexPath.section)
            
        } else {
            if let classes = datasource?.footerClasses(), classes.count > indexPath.section {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: classes[indexPath.section]), for: indexPath) as! CollectionDatasourceCell
            } else if let cls = datasource?.footerClasses()?.first {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: cls), for: indexPath) as! CollectionDatasourceCell
            } else {
                reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: defaultFooterId, for: indexPath) as! CollectionDatasourceCell
            }
            reusableView.datasourceItem = datasource?.footerItem(indexPath.section)
        }
        
        reusableView.controller = self
        
        return reusableView
    }
    
    internal func datasorseUpdate() {
        self.collectionView.reloadData()
    }
    
//    open func getRefreshControl() -> UIRefreshControl {
//        let rc = UIRefreshControl()
//        rc.addTarget(self, action: #selector(CollectionDatasourceController.handleRefresh), for: .valueChanged)
//        return rc
//    }
//    
//    open func handleRefresh() {
//        print("Refresh")
//    }
    
}

