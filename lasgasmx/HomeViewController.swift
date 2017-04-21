//
//  ViewController.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {
    
    lazy var gasPricesCarrousell: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var centerButton: UICenterUser = {
        let cb = UICenterUser(withTarget: self, action:  #selector(HomeViewController.tapOnCenterUserButton), radius: 20)
        return cb
    }()
    
    var mapView: GMSMapView = {
        let view = GMSMapView()
        return view
    }()
    
    let pager = UICustomePager()
    
    let gasPriceDatasorce = GasPricesDatasorce()
    var gasPricesController : GasPricesCarrouselController? = nil
    var stationsMap: GasStationsMapController? = nil
    
    
    lazy var infoView: InfoView = {
        let iv = InfoView(root: self)
        return iv
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
        stationsMap?.delegate = self
        
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
        pager.numberOfPages = (gasPriceDatasorce.objects != nil) ? gasPriceDatasorce.objects!.count : 1
        
        view.addSubview(mapView)
        view.addSubview(infoView)
        view.addSubview(gasPricesCarrousell)
        view.addSubview(pager)
        view.addSubview(centerButton)
        
        pager.anchorCenterXToSuperview()
        pager.anchor(top: gasPricesCarrousell.bottomAnchor, left: gasPricesCarrousell.leftAnchor, bottom: nil, right: gasPricesCarrousell.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 20)

        gasPricesCarrousell.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 70)
        
        infoView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 320, heightConstant: 50)
        infoView.anchorCenterXToSuperview()
        
        mapView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: infoView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: -50, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        centerButton.anchor(top: nil, left: nil, bottom: infoView
            .topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 10, widthConstant: 40, heightConstant: 40)
    }
    
    func tapOnCenterUserButton() { stationsMap?.setMapInUserPosition() }
    
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

        self.infoView.layoutIfNeeded()

        
        for contrain in self.infoView.constraints {
            if contrain.identifier == "height" {
                self.infoView.removeConstraint(contrain)
            }
            if contrain.identifier == "width" {
                self.infoView.removeConstraint(contrain)
            }
        }
        
        let width = (tappedStation == nil) ? 320 : self.view.bounds.width
        
        let newWidthConstrain = self.infoView.widthAnchor.constraint(equalToConstant: width)
        newWidthConstrain.isActive = true
        newWidthConstrain.identifier = "width"
        
        let heigth = (tappedStation == nil) ? 50 : self.view.bounds.height * 0.7
        let newConstrain = self.infoView.heightAnchor.constraint(equalToConstant: heigth)
        newConstrain.isActive = true
        newConstrain.identifier = "height"
        
        let size = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 500)
        let path = UIBezierPath(roundedRect: size, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 20, height:  20))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.infoView.layer.mask = maskLayer
        
        UIView.animate(withDuration: 0.5, animations: {
            self.gasPricesCarrousell.alpha = (tappedStation == nil) ? 1 : 0
            self.pager.alpha = (tappedStation == nil) ? 1 : 0
            self.centerButton.alpha = (tappedStation == nil) ? 1 : 0
            self.infoView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: { flag in
            if width == 320 {
                let path = UIBezierPath(roundedRect: self.infoView.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 20, height:  20))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                self.infoView.layer.mask = maskLayer
            }
        })
    }
}
