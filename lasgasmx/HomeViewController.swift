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

class HomeViewController: UIViewController, GADBannerViewDelegate, GMSMapViewDelegate {
    
    
//    private var gasPricesCarouselController: GasPricesCarouselController!
    // TODO: Crear capa de Carrousel
    lazy var gasPricesCarrousell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .red
        return cv
    }()
    
//    private var stationsMapController: GasPricesCarouselController!
//    private var adModController: GasPricesCarouselController!

    // TODO: Crear capa de Ads
    let adsView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // TODO: Crear capa de maps
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // TODO: Data Sorce
        // TODO: Injectar Repositorio de locaciones gasolineras
        // TODO: Injectar Repositorio de precios estados
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var orientations:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupSubViews()
        mapView.delegate = self
        
        let datasorce = GasPricesDatasorce()
        let gasPricesDatasorce = GasPricesCarrouselController(collectionView: gasPricesCarrousell, datasorce: datasorce)
//        let gasPricesDatasorce = CollectionViewDataSource<UICollectionViewCell>(collectionView: gasPricesCarrousell)
        gasPricesCarrousell.dataSource = gasPricesDatasorce
        gasPricesCarrousell.delegate = gasPricesDatasorce
        
    }
    
    func setupNavigationBar() {
        if let nav = self.navigationController {
            nav.isNavigationBarHidden = true
        }
    }
    
    func setupSubViews() {
        
        adsView.adUnitID = "ca-app-pub-2278511226994516/3431553183"
        adsView.rootViewController = self
        adsView.delegate = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adsView.load(request)
        
        view.addSubview(mapView)
        view.addSubview(adsView)
        view.addSubview(gasPricesCarrousell)
        
        gasPricesCarrousell.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 60)
        
        adsView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        adsView.anchorCenterXToSuperview()
        
        mapView.fillSuperview()
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 100))
        infoWindow.backgroundColor = .cyan
        return infoWindow
    }
    
}