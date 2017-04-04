//
//  SelectCityTable.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/31/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//


//  gasPricesCarouselDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

protocol SelectCityCollectionDelegate {
    func itemsSelected(location: GasPriceLocation?)
}

class SelectCityCollectionController: CollectionDatasourceController  {
    
    var gasPricesLocation : GasPriceLocation? = nil
    var delegate: SelectCityCollectionDelegate? = nil
    
    override init(collectionView: UICollectionView, datasorce: CollectionDatasource) {
        super.init(collectionView: collectionView, datasorce: datasorce)
        
        guard let data = datasource as? SelectCityDatasorce else {
            return
        }
        data.getData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupViews(collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let d = delegate else { return }
        if let data = datasource as? SelectCityDatasorce {
            let result = data.setSectionby(index: indexPath)
            d.itemsSelected(location: result)
            datasorseUpdate()
        }
    }
    
    override func sectionHeaderTapped(at indexPath: Int){
        if let data = datasource as? SelectCityDatasorce {
            data.headers[indexPath].isSectionActive = !data.headers[indexPath].isSectionActive
            datasorseUpdate()
        }
    }
}

