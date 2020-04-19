//
//  AppDelegate.swift
//  TaxiApp
//
//  Created by Developer on 25.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router = AuthRouter(navigationController: UINavigationController())

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyCJk2hF867IudI0UP_vh-16i6eR4r5BioI")
        GMSPlacesClient.provideAPIKey("AIzaSyCJk2hF867IudI0UP_vh-16i6eR4r5BioI")
        FireStoreManager.shared.configure()

        window = UIWindow()
        window?.rootViewController = router.navigationController
        router.start()
        window?.makeKeyAndVisible()
        return true
    }
}
