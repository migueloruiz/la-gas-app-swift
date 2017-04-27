//
//  ViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMobileAds

class HomeViewController: UIViewController {
    
    let gasPriceDatasorce = GasPricesDatasorce()
    var gasPricesController : GasPricesCarrouselController? = nil
    var stationsMap: GasStationsMapController? = nil
    
    var adsManeger: AdModManager? = nil
    var adsView: GADBannerView? = nil
    
    let pager = UICustomePager()
    
    lazy var gasPricesCarrousell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var centerButton: UIMapControlButton = {
        let cb = UIMapControlButton(withTarget: self, action: #selector(HomeViewController.tapOnCenterUserButton), radius: 20, type: .navigation)
        cb.imageEdgeInsets = UIEdgeInsetsMake(10, 4, 7, 7)
        return cb
    }()
    
    lazy var controlsButton: UIMapControlButton = {
        let cb = UIMapControlButton(withTarget: self, action: #selector(HomeViewController.filterMap), radius: 20, type: .controls)
        cb.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        return cb
    }()
    
    lazy var closeInfoButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(HomeViewController.closeInfo), for: .touchUpInside)
        b.backgroundColor = .clear
        b.tintColor = .black
        b.setImage( #imageLiteral(resourceName: "down-arrow").withRenderingMode(.alwaysTemplate), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.alpha = 0
        return b
    }()
    
    var mapView: GMSMapView = {
        let view = GMSMapView()
        return view
    }()
    
    lazy var infoView: InfoView = {
        let iv = InfoView(root: self)
        iv.alpha = 0
        return iv
    }()
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    init( adsManager: AdModManager) {
        super.init(nibName: nil, bundle: nil)
        self.adsManeger = adsManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        stationsMap = GasStationsMapController(map: mapView)
        stationsMap?.delegate = self
        
        gasPricesController = GasPricesCarrouselController(collectionView: gasPricesCarrousell, datasorce: gasPriceDatasorce)
        gasPricesController?.delegate = self
        gasPriceDatasorce.fetchStroage()
        
        setupSubViews()
        setAds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        gasPriceDatasorce.updateCarrousell()
        stationsMap?.askForUserLocation()
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
    }
    
    func setupNavigationBar() {
        guard let nav = self.navigationController else { return }
        nav.isNavigationBarHidden = true
    }
    
    func setupSubViews() {
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
        
        view.addSubview(mapView)
        view.addSubview(infoView)
        view.addSubview(gasPricesCarrousell)
        view.addSubview(pager)
        view.addSubview(centerButton)
        view.addSubview(controlsButton)
        view.addSubview(closeInfoButton)
        
        pager.anchorCenterXToSuperview()
        pager.anchor(top: gasPricesCarrousell.bottomAnchor, left: gasPricesCarrousell.leftAnchor, bottom: nil, right: gasPricesCarrousell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)

        gasPricesCarrousell.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 70)
        
        infoView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        infoView.anchorCenterXToSuperview()
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: infoView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        centerButton.anchor(top: nil, left: nil, bottom: infoView
            .topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 60, rightConstant: 5, widthConstant: 40, heightConstant: 40)
        
        controlsButton.anchor(top: nil, left: nil, bottom: centerButton.topAnchor, right: centerButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        closeInfoButton.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: nil, topConstant: 25, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)

    }
    
    func setAds() {
        guard let ad = adsManeger else { return }
        
        adsView = ad.getBanner(with: "3431553183")
        adsView?.rootViewController = self
        
        let request = ad.getTestRequest()
        adsView?.load(request)
        
        view.addSubview(adsView!)
        adsView?.anchor(top: nil, left: nil, bottom: mapView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        adsView?.anchorCenterXToSuperview()
    }
    
    func tapOnCenterUserButton() { stationsMap?.setCameraInUserPosition() }
    
    func filterMap() {
//        stationsMap?.filterBy(type: .Magna)
    }
    
    
    func closeInfo() {
        animateInfoView(with: nil)
        stationsMap?.setLastCameraPosition()
    }
    
    func animateInfoView(with station: GasStation?) {
        let isNil = (station == nil)
        self.infoView.gasStation = station
        self.infoView.layoutIfNeeded()
        
        for contrain in self.infoView.constraints {
            if contrain.identifier == "height" {
                self.infoView.removeConstraint(contrain)
            }
        }
        
        let heigth = (station == nil) ? 0 : self.view.bounds.height * 0.37
        let newConstrain = self.infoView.heightAnchor.constraint(equalToConstant: heigth)
        newConstrain.isActive = true
        newConstrain.identifier = "height"
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.gasPricesCarrousell.alpha = isNil ? 1 : 0
            self.pager.alpha = isNil ? 1 : 0
            self.centerButton.alpha = isNil ? 1 : 0
//            self.controlsButton.alpha = isNil ? 1 : 0
            self.closeInfoButton.alpha = isNil ? 0 : 1
            self.infoView.alpha = isNil ? 0 : 1
            
            if let ad = self.adsView {
                ad.alpha = isNil ? 1 : 0
            }

            self.infoView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        })
    }
    
}

extension HomeViewController: GasPricesCarrouselDelegate {
    
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
        guard let nav = self.navigationController else { return }
        nav.pushViewController(CalculatorViewController(gasPrice: price), animated: true)
    }

    internal func gasEmptyCellSelected() {
        guard let nav = self.navigationController else { return }
        nav.pushViewController(NewLocationViewController(), animated: true)
    }
}

extension HomeViewController: GasStationsMapDelegate {
    func gasStation(tappedStation: GasStation?) {
        animateInfoView(with: tappedStation)
    }
}
