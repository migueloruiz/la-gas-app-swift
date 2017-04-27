//
//  InfoView+ShowDirectionOptions.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/25/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct MapsApp {
    let name: String
    var urlGenerator: (CLLocationCoordinate2D) -> String
}

extension InfoView {
    
    internal func generateAction(app: MapsApp, location: CLLocationCoordinate2D) -> UIAlertAction {
        let action = UIAlertAction(title: app.name, style: .default, handler: { _ in
            let url = URL(string: app.urlGenerator(location) )!
            UIApplication.shared.open(url, options: [:], completionHandler: { result in
                print(result)
            })
        })
        return action
    }
    
    internal func generateAppleMapsAction(location: CLLocationCoordinate2D) -> UIAlertAction {
        return UIAlertAction(title: "Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let regionDistance:CLLocationDistance = 100;
            let regionSpan = MKCoordinateRegionMakeWithDistance((location), regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)]
            
            let placemark = MKPlacemark(coordinate: (location))
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.gasStation?.name
            mapItem.openInMaps(launchOptions: options)
        })
    }
    
    internal func showDirectionsOptions () {
        
        guard let location = gasStation?.location else { return }
        
        let apps = [
            MapsApp(name: "Google Maps", urlGenerator: { l in  return "comgooglemaps://?saddr=&daddr=\(l.latitude),\(l.longitude)&directionsmode=driving"}),
            MapsApp(name: "Waze", urlGenerator: {l in "waze://?ll=\(l.latitude),\(l.longitude)&navigate=yes"})
        ]
        
        let optionMenu = UIAlertController(title: nil, message: "Abrir direccion en", preferredStyle: .actionSheet)
        
        for app in apps {
            let action = generateAction(app: app, location: location)
            optionMenu.addAction(action)
        }

        let maps = generateAppleMapsAction(location: location)
        optionMenu.addAction(maps)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        self.rootViewController?.present(optionMenu, animated: true, completion: nil)
    }
}


