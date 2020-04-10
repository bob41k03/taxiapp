//
//  ViewController.swift
//  TaxiApp
//
//  Created by Developer on 25.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import GoogleMaps
import SideMenu
import PullUpController

class MapViewController: UIViewController {

    @IBOutlet private weak var mapView: GMSMapView!

    // MARK: - Variables
    let locationManager = CLLocationManager()
//    var fromLocation = AddressesViewController().fromLocation {
//        didSet {
//            if fromLocation != nil {
//
//                let fromLocation = self.fromLocation!.coordinate
//                let fromMarker = GMSMarker(position: fromLocation)
//                fromMarker.map = mapView
//                let fromLocationCamera = GMSCameraPosition.camera(withTarget: fromLocation, zoom: 10)
//                mapView.camera = fromLocationCamera
//            }
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setupPullUpController()
        setupMenu()
    }




    // MARK: - IBAction
    @IBAction private func menuItemClicked(_ sender: UIBarButtonItem) {
        showMenu()
    }
    
// MARK: - Private
    private func showMenu() {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            present(menu, animated: true, completion: nil)
        }
    }

    private func setupPullUpController() {
        let pullUpController =  UIStoryboard(name: "Addresses",bundle: nil).instantiateViewController(withIdentifier: "AddressesViewController") as! AddressesViewController
        addPullUpController(pullUpController, initialStickyPointOffset: 110, animated: true)
        addChild(pullUpController)
        self.view.addSubview(pullUpController.view)
        pullUpController.didMove(toParent: self)
    }
    
    private func setupMenu() {
        let leftMenu = Storyboard.menu.instanceOf(viewController: MenuTableViewController.self)!
        let menuLeftNavigationController = SideMenuNavigationController(rootViewController: leftMenu)
        menuLeftNavigationController.leftSide = true
        let menuPresentationStyle: SideMenuPresentationStyle = .viewSlideOut
        menuPresentationStyle.menuStartAlpha = 0
        menuPresentationStyle.onTopShadowOpacity = 1
        var settings = SideMenuSettings()
        settings.presentationStyle = menuPresentationStyle
        settings.statusBarEndAlpha = 0
        menuLeftNavigationController.settings = settings
        menuLeftNavigationController.setNavigationBarHidden(true, animated: true)
        SideMenuManager.default.leftMenuNavigationController = menuLeftNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view, forMenu: .left)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
        return
    }
    mapView.isMyLocationEnabled = true
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

        let currentLocation = location.coordinate
        let marker = GMSMarker(position: currentLocation)
        marker.icon = UIImage(named: "mapLocation")
        marker.map = mapView
        mapView.camera = GMSCameraPosition(target: currentLocation, zoom: 15, bearing: 0, viewingAngle: 0)

    locationManager.stopUpdatingLocation()
  }
}
