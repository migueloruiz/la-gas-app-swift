//
//  AppDelegate.swift
//  lasgasmx
//
//  Created by Desarrollo on 3/21/17.
//  Copyright © 2017 migueloruiz. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigation: UINavigationController? = nil
    let configManager = PrivateKeysManager(byPlistFile: "PrivateKeys")
    var rootViewController: UIViewController = UIViewController()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FIRApp.configure()
        
        GMSServices.provideAPIKey(configManager["GOOGLE_MAPS_KEY"])
        
        let userDefaults = UserDefaultsManager()
        let firstLaunch = userDefaults.isFistLaunch()
        
        // TODO: Revisar si la locacion esta Activa
        // GasStationsMapController.isLocationServicesEnabled()
        // Y mandar a Mapa o vista de error
        
        if firstLaunch == nil {
            rootViewController = TutorialViewController()
        } else {
            let adsManager = AdModManager.init(key: configManager["AD_MOD_ID"])
            rootViewController = HomeViewController( adsManager: adsManager )
        }
        
        mainNavigation = UINavigationController(rootViewController: rootViewController )
        window?.rootViewController = mainNavigation
        return true
    }


    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "lasgasmx")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

