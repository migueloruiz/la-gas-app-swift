//
//  InfoView+ShowDirectionOptions.swift
//  lasgasmx
//
//  Created by Desarrollo on 4/25/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import MapKit

extension InfoView {
    
    func showDirectionsOptions () {
        
        let optionMenu = UIAlertController(title: nil, message: "Abrir direccion en:", preferredStyle: .actionSheet)
        
        
        // TODO: HACER ESTA SECCION mucho mas modular con un diccionario
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            let google = UIAlertAction(title: "Google Maps", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.openURL(URL(string: "comgooglemaps://?saddr=&daddr=\(self.gasStation?.location.latitude),\(self.gasStation?.location.longitude)&directionsmode=driving")!)
            })
            optionMenu.addAction(google)
        }
        
        if (UIApplication.shared.canOpenURL(URL(string:"waze://")!)) {
            let waze = UIAlertAction(title: "Waze", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                UIApplication.shared.openURL(URL(string: "waze://?ll=\(self.gasStation?.location.latitude),\(self.gasStation?.location.longitude)&navigate=yes")!)
            })
            optionMenu.addAction(waze)
        }
        
        let maps = UIAlertAction(title: "Maps", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let regionDistance:CLLocationDistance = 100;
            let regionSpan = MKCoordinateRegionMakeWithDistance((self.gasStation?.location)!, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center)]
            
            let placemark = MKPlacemark(coordinate: (self.gasStation?.location)!)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = self.gasStation?.name
            mapItem.openInMaps(launchOptions: options)
        })
        optionMenu.addAction(maps)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(cancelAction)
        
        self.rootViewController?.present(optionMenu, animated: true, completion: nil)
    }
}


