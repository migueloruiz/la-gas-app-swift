//
//  TodayViewController.swift
//  La Gas Widget
//
//  Created by Desarrollo on 4/26/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    lazy var gasPriceDatasorce: GasPricesDatasorce = {
        let configManager = PrivateKeysManager(byPlistFile: "PrivateKeys")
        let api = GasApiManager(baseUrl: configManager["API_BASE_URL"])
        let ud = UserDefaultsManager(suitName: configManager["GROUP_KEY"])
        print("gasPriceDatasorce")
        return GasPricesDatasorce(api: api, userDefaults: ud!)
    }()
    
    var gasPricesController : GasPricesCarrouselController? = nil
    
    let backImage: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate) )
        i.contentMode = .scaleAspectFit
        i.tintColor = .gray
        return i
    }()
    
    let frontImage: UIImageView = {
        let i = UIImageView(image: #imageLiteral(resourceName: "font").withRenderingMode(.alwaysTemplate) )
        i.contentMode = .scaleAspectFit
        i.tintColor = .orange
        return i
    }()
    
    var pager: UICustomePager = {
        let pc = UICustomePager()
        pc.addTarget(self, action: #selector(TodayViewController.pageChange(sender:)), for: .valueChanged)
        return pc
    }()
    
    lazy var gasPricesCarrousell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gasPricesController = GasPricesCarrouselController(collectionView: gasPricesCarrousell, datasorce: gasPriceDatasorce)
        gasPricesController?.lateralSpace = 5
        gasPricesController?.delegate = self
        
        setupSubViews()
    }
    
    func setupSubViews() {
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
        
        view.addSubview(gasPricesCarrousell)
        view.addSubview(backImage)
        view.addSubview(frontImage)
        view.addSubview(pager)
        
        pager.anchorCenterXToSuperview()
        pager.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 35)
        
        backImage.anchor(top: pager.topAnchor, left: view.leftAnchor, bottom: pager.bottomAnchor, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 10, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        frontImage.anchor(top: pager.topAnchor, left: nil, bottom: pager.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        gasPricesCarrousell.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: pager.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func pageChange(sender: UIPageControl) {
        let index = IndexPath(item: sender.currentPage, section: 0)
        gasPricesCarrousell.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        backImage.tintColor = (sender.currentPage == 0) ? .gray : .orange
        frontImage.tintColor = (sender.currentPage == sender.numberOfPages - 1) ? .gray : .orange
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {        
        gasPriceDatasorce.fetchResurces(completition: { newData in
            if newData {
                completionHandler(NCUpdateResult.newData)
            } else {
                completionHandler(NCUpdateResult.noData)
            }
        })
    }
    
}

extension TodayViewController: GasPricesCarrouselDelegate {
    func datasourseWasUpdated() {
        guard let items = gasPriceDatasorce.objects else { return }
        pager.numberOfPages = items.count
    }
    
    internal func updateCounter(counter: Int) {
        guard let items = gasPriceDatasorce.objects else {
            pager.numberOfPages = 1
            pager.currentPage = 1
            return
        }
        pager.numberOfPages = items.count
        pager.currentPage = counter
    }
    
    internal func gasCellSelected(price: GasPriceInState) {
        print("gasCellSelected")
    }
    
    internal func gasEmptyCellSelected() {
        print("gasEmptyCellSelected")
    }
}
