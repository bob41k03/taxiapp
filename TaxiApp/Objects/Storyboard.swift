//
//  StoryboardManager.swift
//  TaxiApp
//
//  Created by Developer on 29.02.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit

enum Storyboard: String {

    case map = "Map"
    case menu = "Menu"
    case registration = "Registration"
    case login = "Login"
    case forgotPassword = "ForgotPassword"
    case profile = "Profile"
    case ordersHistory = "OrdersHistory"

    var instance: UIStoryboard {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        return storyboard
    }

    func instanceOf<T: UIViewController>(viewController: T.Type,
                                         identifier viewControllerIdentifier: String? = nil) -> T? {
        if let identifier = viewControllerIdentifier {
            return instance.instantiateViewController(withIdentifier: identifier) as? T
        }
        return instance.instantiateInitialViewController() as? T
    }
}
