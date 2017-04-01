
//  gasPricesCarouselDatasorce.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/29/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit

protocol GasPricesCarrouselDelegate {
    func updateCounter(counter: Int)
    func gasEmptyCellSelected()
}

class GasPricesCarrouselController: CollectionDatasourceController {
    
    let lateralSpace: CGFloat = 30
    var delegate: GasPricesCarrouselDelegate? = nil
    
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dl = delegate else {
            print("GasPricesCarrouselController.delagete no set")
            return
        }
        
        guard (type(of: collectionView.cellForItem(at: indexPath)) == GasPriceCell.self) else {
            dl.gasEmptyCellSelected()
            return
        }
        print("Abrir calculadora")
    }
    
}

