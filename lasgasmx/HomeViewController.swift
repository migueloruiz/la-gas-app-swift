//
//  ViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GoogleMaps

class HomeViewController: UIViewController {
    
    lazy var gasPricesCarrousell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    var mapView: GMSMapView = {
        let view = GMSMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let camera = GMSCameraPosition.camera(withLatitude: 19.4406926, longitude: -99.2047001, zoom: 17)
        view.camera = camera
        view.isMyLocationEnabled = true
        
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(19.4406926, -99.2047001)
                marker.title = "Sydney"
                marker.snippet = "Australia"
                marker.icon = UIImage(named: "locationIcon")
                marker.map = view
        
        return view
    }()
    
    let pager = UICustomePager()
    
    let gasPriceDatasorce = GasPricesDatasorce()
    var gasPricesController : GasPricesCarrouselController? = nil
    var stationsMap: GasStationsMapController? = nil

    // TODO: Crear capa de Ads
    let adsView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() { super.init(nibName: nil, bundle: nil) }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        gasPricesController = GasPricesCarrouselController(collectionView: gasPricesCarrousell, datasorce: gasPriceDatasorce)
        gasPricesController?.delegate = self
        gasPriceDatasorce.fetchStroage()
        
        stationsMap = GasStationsMapController(map: mapView)
        
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        gasPriceDatasorce.updateCarrousell()
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
    }
    
    func setupNavigationBar() {
        guard let nav = self.navigationController else { return }
        nav.isNavigationBarHidden = true
    }
    
    func setupSubViews() {
        adsView.adUnitID = "ca-app-pub-2278511226994516/3431553183"
        adsView.rootViewController = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adsView.load(request)
        
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
        
        view.addSubview(mapView)
        view.addSubview(adsView)
        view.addSubview(gasPricesCarrousell)
        view.addSubview(pager)
        
        pager.anchorCenterXToSuperview()
        pager.anchor(top: gasPricesCarrousell.bottomAnchor, left: gasPricesCarrousell.leftAnchor, bottom: nil, right: gasPricesCarrousell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)

        gasPricesCarrousell.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 70)
        
        adsView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        adsView.anchorCenterXToSuperview()
        
        mapView.fillSuperview()
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
