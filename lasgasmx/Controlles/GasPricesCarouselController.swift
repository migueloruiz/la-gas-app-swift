
//  gasPricesCarouselDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

protocol GasPricesCarrouselControllerCounter {
    func updateCounter(counter: Int)
}

class GasPricesCarrouselController: CollectionDatasourceController {
    
    let lateralSpace: CGFloat = 30
    var delegate: GasPricesCarrouselControllerCounter? = nil
    
    override func setupViews(collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear
    }
    

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - (lateralSpace * 2), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, lateralSpace, 0, lateralSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lateralSpace * 2
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard let dl = delegate else {
            print("GasPricesCarrouselController.delagete no set")
            return
        }
        let counter = targetContentOffset.pointee.x / scrollView.frame.width
        dl.updateCounter(counter: Int(counter))
    }
    
}


