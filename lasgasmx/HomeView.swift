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

class HomeView: UIViewController, GADBannerViewDelegate, GMSMapViewDelegate {
    
    let gasPricesCarrousell: gasPriceView = {
        return gasPriceView()
    }()
    
    let adsView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    var orientations:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
        mapView.delegate = self
    }
    
    func setupSubViews() {
        
        let configKeysManager = ConfigKeysManager()
        adsView.adUnitID = "ca-app-pub-2278511226994516/3431553183"
        adsView.rootViewController = self
        adsView.delegate = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adsView.load(request)
        
        view.addSubview(mapView)
        view.addSubview(adsView)
        view.addSubview(gasPricesCarrousell)

        gasPricesCarrousell.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor , constant: 10).isActive = true
        gasPricesCarrousell.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        gasPricesCarrousell.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        gasPricesCarrousell.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        gasPricesCarrousell.heightAnchor.constraint(equalToConstant: 60 ).isActive = true
        
        adsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        adsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
//        adsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        adsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        adsView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        adsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.topAnchor.constraint(equalTo: view.topAnchor , constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        
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

//class HomeView: UICollectionViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView?.backgroundColor = .white
//        navigationItem.title = "Hola"
//    }
//    
//}


//        let requestURL: URL = URL(string: "https://lagasmx.herokuapp.com/states")!
//        let urlRequest: URLRequest = URLRequest(url: requestURL)
//        let session = URLSession.shared
//        let task = session.dataTask(with: urlRequest) {
//            (data, response, error) -> Void in
//
//            let httpResponse = response as! HTTPURLResponse
//            let statusCode = httpResponse.statusCode
//
//            if (statusCode == 200) {
//                do{
//                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
//                    print(json)
//
//                }catch {
//                    print("Error with Json: \(error)")
//                }
//            }
//        }
//
//        task.resume()

