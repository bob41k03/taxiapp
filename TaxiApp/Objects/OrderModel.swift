//
//  OrderModel.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 07.04.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import Foundation

struct Order: Codable, Identifiable {
    var id: String? = nil
    var date: String
    var from: String
    var toDestination: String
    var price: String
    var comment: String?
    var uid: String
    var status: String
    var fromLatitudeCoordinate: Double
    var fromLongitudeCoordinate: Double
    var toLatitudeCoordinate: Double
    var toLongitudeCoordinate: Double

    init(date: String, from: String,
         toDestination: String, price: String,
         comment: String, uid: String,
         status: String, fromLatitudeCoordinate: Double,
         fromLongitudeCoordinate: Double, toLatitudeCoordinate: Double, toLongitudeCoordinate: Double) {
        self.date = date
        self.from = from
        self.toDestination = toDestination
        self.price = price
        self.comment = comment
        self.uid = uid
        self.status = status
        self.fromLatitudeCoordinate = fromLatitudeCoordinate
        self.fromLongitudeCoordinate = fromLongitudeCoordinate
        self.toLatitudeCoordinate = toLatitudeCoordinate
        self.toLongitudeCoordinate = toLongitudeCoordinate
    }
}
