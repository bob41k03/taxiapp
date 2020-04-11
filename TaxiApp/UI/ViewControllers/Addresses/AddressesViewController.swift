//
//  AddressesViewController.swift
//  TaxiApp
//
//  Created by Ihor Vozhdai on 02.04.2020.
//  Copyright © 2020 Developer. All rights reserved.
//

import UIKit
import PullUpController
import Firebase
import GoogleMaps
import GooglePlaces

class AddressesViewController: PullUpController {

    // MARK: - IBOutlets
    @IBOutlet private weak var fromTextField: UITextField!
    @IBOutlet private weak var toTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var commentsTextField: UITextField!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Variables
    override var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
    var orders = [Order]()
    var fromLocation: CLLocation? {
        didSet {
            if fromLocation != nil {

            }
        }
    }
    var toLocation: CLLocation?


    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        FireStoreManager.shared.read(from: .orders, returning: Order.self) { (orders) in
            self.orders = orders
        }
        cancelButton.isHidden = true
        orderButton.isEnabled = false
        orderButton.backgroundColor = .gray
        fromTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        toTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
    }

    // validate order button
    @objc private func textFieldsIsNotEmpty() {
        if (fromTextField.text?.isEmpty == false
            || toTextField.text?.isEmpty == false
            || priceTextField.text?.isEmpty == false) {
            orderButton.isEnabled = true
            orderButton.backgroundColor = #colorLiteral(red: 0.9278113842, green: 0.4737780094, blue: 0, alpha: 1)
        }
    }

    // convert adress(String) to coordinate(CLLocation)
    func getFromCoordinate() {
        let address = fromTextField.text
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            self.fromLocation = location
        }
    }

    // convert adress(String) to coordinate(CLLocation)
    func getToCoordinate() {
        let address = toTextField.text
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    return
            }
            self.toLocation = location
        }
    }

    // update order status if order was canceled
    func updateOrderStatus() {
        let currentUserUid = Auth.auth().currentUser?.uid
        let currentOrder = orders.filter { $0.uid == currentUserUid && $0.status == OrderStatuses.new.rawValue }
        let currentOrderId = currentOrder[0].id
        let ref = FireStoreManager.shared.reference(to: .orders)
        ref.document(currentOrderId!).setData(["status" : OrderStatuses.canceled.rawValue], merge: true)
    }

    // MARK: - IBActions

    @IBAction func fromTapped(_ sender: Any) {
        fromTextField.resignFirstResponder()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.view.tag = 1
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    @IBAction func toTapped(_ sender: Any) {
        toTextField.resignFirstResponder()
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.view.tag = 2
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func toOrderTapped(_ sender: UIButton) {
        let currentUid = Auth.auth().currentUser!.uid
        let newOrder = Order(from: fromTextField.text!, to: toTextField.text!, price: priceTextField.text!, comment: commentsTextField.text ?? "", uid: currentUid, status: OrderStatuses.new.rawValue, fromLatitudeCoordinate: (fromLocation?.coordinate.latitude)!, fromLongitudeCoordinate: (fromLocation?.coordinate.longitude)!, toLatitudeCoordinate: (toLocation?.coordinate.latitude)!, toLongitudeCoordinate: (toLocation?.coordinate.longitude)!)
        FireStoreManager.shared.create(for: newOrder, in: .orders)

        let alert = UIAlertController(title: "Info", message: "Your order was created.", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            self.orderButton.isHidden = true
            self.cancelButton.isHidden = false
        })
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func toCancelTapped(_ sender: UIButton) {

        updateOrderStatus()

        cancelButton.isHidden = true
        orderButton.isHidden = false
        fromTextField.text = ""
        toTextField.text = ""
        priceTextField.text = ""
        commentsTextField.text = ""
        orderButton.isEnabled = false
        orderButton.backgroundColor = .gray

        let alert = UIAlertController(title: "Info", message: "Your order was canceled.", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
}

extension AddressesViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        if viewController.view.tag == 1 {
            fromTextField.text = place.formattedAddress
            getFromCoordinate()
        } else if viewController.view.tag == 2 {
            toTextField.text = place.formattedAddress
            getToCoordinate()
        }
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
