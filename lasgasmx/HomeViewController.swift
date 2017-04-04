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
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    let pager : UIPageControl = {
        let pg = UIPageControl(frame: .zero)
        pg.translatesAutoresizingMaskIntoConstraints = false
        pg.pageIndicatorTintColor = .gray
        pg.currentPageIndicatorTintColor = .orange
        pg.backgroundColor = .clear
        return pg
    }()
    
    let gasPriceDatasorce = GasPricesDatasorce()
    var gasPricesController : GasPricesCarrouselController? = nil
    
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
        // TODO: Data Sorce
        // TODO: Injectar Repositorio de locaciones gasolineras
        // TODO: Injectar Repositorio de precios estados
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var orientations:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        gasPricesController = GasPricesCarrouselController(collectionView: gasPricesCarrousell, datasorce: gasPriceDatasorce)
        gasPricesController?.delegate = self
        mapView.delegate = self
        
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
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
        
        
        if let items = gasPriceDatasorce.objects {
            pager.numberOfPages = items.count
        } else {
            pager.numberOfPages = 1
        }
        
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

extension HomeViewController: GasPricesCarrouselDelegate {
    internal func gasEmptyCellSelected() {
        guard let nav = self.navigationController else {
            print("No NavigationControlle abilable")
            return
        }
        
//        let location =  GasPriceLocation(state: "AGUASCALIENTES", city: "JESUS MARIA")
//        nav.pushViewController(NewLocationViewController(location: location), animated: true)
        
        nav.pushViewController(NewLocationViewController(), animated: true)
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
}
