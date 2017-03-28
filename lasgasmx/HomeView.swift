//
//  ViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeView: UIViewController, GADBannerViewDelegate {
    
    let gasPicker: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    let adsView: GADBannerView = {
        let view = GADBannerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    var orientations:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews()
    }
    
    func setupSubViews() {
        
        let configKeysManager = ConfigKeysManager()
        let id = configKeysManager.getConfigValue(byKey: "AdMobID")
        adsView.adUnitID = "ca-app-pub-2278511226994516/3431553183"
        adsView.rootViewController = self
        adsView.delegate = self
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        adsView.load(request)
        
        view.addSubview(gasPicker)
        view.addSubview(adsView)
        view.addSubview(mapView)
        
//        gasPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
//        gasPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor ).isActive = true
//        gasPicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
//        gasPicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true

        gasPicker.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor , constant: 0).isActive = true
        gasPicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        gasPicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        gasPicker.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        gasPicker.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.08 ).isActive = true
        
        adsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        adsView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        adsView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        adsView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        adsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mapView.topAnchor.constraint(equalTo: gasPicker.bottomAnchor , constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: adsView.topAnchor , constant: 0).isActive = true
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

