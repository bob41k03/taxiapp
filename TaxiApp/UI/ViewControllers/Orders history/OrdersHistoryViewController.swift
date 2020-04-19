//
//  OrdersHistoryViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai 
//  Copyright © 2020 Developer. All rights reserved.

import UIKit
import Firebase

class OrderCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var fromLabel: UILabel!
    @IBOutlet fileprivate weak var toLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
}

class OrdersHistoryViewController: UITableViewController {

    // MARK: - Variables
    var orders = [Order]()

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        getOrders()
    }

    func getOrders() {
        FireStoreManager.shared.read(from: .orders, returning: Order.self) { orders in
            let orders = orders
            let currentUserOrders = orders.filter { $0.uid == Auth.auth().currentUser?.uid }
            self.orders = currentUserOrders
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ordersCount = self.orders.count
        return ordersCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderCell
        cell?.dateLabel.text = orders[indexPath.row].date
        cell?.fromLabel.text = orders[indexPath.row].from
        cell?.toLabel.text = orders[indexPath.row].to
        cell?.priceLabel.text = orders[indexPath.row].price
        return cell!
    }
}
