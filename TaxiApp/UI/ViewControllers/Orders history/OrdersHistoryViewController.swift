//
//  OrdersHistoryViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai 
//  Copyright © 2020 Developer. All rights reserved.

import UIKit
import Firebase

class OrdersHistoryViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Variables
    var orders = [Order]()
    let group = DispatchGroup()

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        getOrders()
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    func getOrders() {
        group.enter()
        FireStoreManager.shared.read(from: .orders, returning: Order.self) { (orders) in
            self.orders = orders
            self.group.leave()
        }
    }
}

extension OrdersHistoryViewController: UITableViewDataSource, UITableViewDelegate {

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.dateTimeLabel.text = "19.04"
        cell.fromLabel.text = orders[indexPath.row].from
        cell.toLabel.text = orders[indexPath.row].to
        cell.priceLabel.text = orders[indexPath.row].price
        return cell
    }
}

