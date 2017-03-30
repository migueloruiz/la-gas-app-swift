//
//  CollectionDatasorceCell.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

/// DatasourceCell is the base cell class for all headers, cells, and footers used in DatasourceController and Datasource.  Using this cell, you can access the row's model object via datasourceItem.  You can also access the controller as well.
open class CollectionDatasourceCell: UICollectionViewCell {
    
    open var datasourceItem: Any?
    open weak var controller: CollectionDatasourceController?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    open func setupViews() { }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
