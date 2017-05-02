//
//  CalcResultsCollectionController.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/7/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

class CalcResultsCollectionController: CollectionDatasourceController  {
    
    var keboardHeigth: CGFloat = 200
    
    override func setupViews(collectionView: UICollectionView) {
        collectionView.backgroundColor = .white
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = (collectionView.frame.height - keboardHeigth) / 3
        return CGSize(width: collectionView.frame.width, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
