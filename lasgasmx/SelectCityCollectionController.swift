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

class SelectCityCollectionController: CollectionDatasourceController {
    
    // TODO: Costructor con stado y ciudad
    // injectados
    
    // TODO: Init elements
    
    // TODO: GasPricesLocation
    var gasPricesLocation : GasPriceLocation? = nil
    
    //TODO validacion state y city

    
    override init(collectionView: UICollectionView, datasorce: CollectionDatasource) {
        super.init(collectionView: collectionView, datasorce: datasorce)
        
        guard let data = datasource as? SelectCityDatasorce else {
            return
        }
        data.fetchData()
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
        setSectionby(index: indexPath )
    }
    
    override func sectionHeaderTapped(at indexPath: Int){
        if let data = datasource as? SelectCityDatasorce {
            data.headers[indexPath].isSectionActive = !data.headers[indexPath].isSectionActive
            datasorseUpdate()
        }
    }
    
    func setSectionby(index: IndexPath){
        guard let data = datasource as? SelectCityDatasorce else {
            return
        }
        
        let selectedItem = (index.section > 0) ?  data.citys[index.item] : data.states[index.item]
        
        let indexSection = index.section
        data.headers[indexSection].slectedItem = selectedItem
        data.headers[indexSection].isSectionActive = false
        
        if indexSection + 1 < data.headers.count {
            data.headers[indexSection + 1].isSectionActive = true
        } else {
            print("seleccion terminada \(data.headers[0].slectedItem), \(data.headers[1].slectedItem)")
        }
        datasorseUpdate()
    }
}

