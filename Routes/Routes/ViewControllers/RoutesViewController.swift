//
//  ViewController.swift
//  Routes
//
//  Created by Vitor Costa on 10/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import MaterialComponents

class RoutesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fromTextField: MDCTextField!
    @IBOutlet weak var toTextField: MDCTextField!
    @IBOutlet weak var searchButton: MDCButton!
    
    // MARK: - Private properties
    private var fromTFController:MDCTextInputControllerOutlined!
    private var toTFController:MDCTextInputControllerOutlined!
    private var searchBTScheme:MDCButtonScheme!
    private var mapResult:MapResult!
    
    // MARK: - Private Constants
    private let activeColor:UIColor = UIColor(named: "BasePurple")!
    
    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMap" {
            let vc = segue.destination as! MapViewController
            vc.mapResult = self.mapResult
        }
    }
    
    // MARK: - IBActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        getLocationsFromAddress()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure 'From' TextField
        fromTFController = MDCTextInputControllerOutlined(textInput: fromTextField)
        fromTFController.activeColor = activeColor
        fromTFController.floatingPlaceholderActiveColor = activeColor
        
        // Configure 'To' TextField
        toTFController = MDCTextInputControllerOutlined(textInput: toTextField)
        toTFController.activeColor = activeColor
        toTFController.floatingPlaceholderActiveColor = activeColor
        
        // Configure Search Button
        searchBTScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(searchBTScheme, to: searchButton)
        searchButton.setBackgroundColor(activeColor)
    }
    
    private func getLocationsFromAddress() {
        // Check if places are nil or empty
        guard fromTextField.text != nil && !fromTextField.text!.isEmpty
            &&
            toTextField.text != nil && !toTextField.text!.isEmpty else {
                showAlert(title: "Attention", message: "Places should not be empty!")
                return
        }
        showCenterIndicator()
        setUIMode(false)
        MapHelper.sharedInstance.getMapResultFromAddresses(from: fromTextField.text!, to: toTextField.text!) { (result) in
            self.hideCenterIndicator()
            self.setUIMode(true)
            if let error = result.errorMessage {
                self.showAlert(title: "Attention", message: error)
            } else {
                self.mapResult = result
                self.performSegue(withIdentifier: "segueToMap", sender: nil)
            }
        }
    }
    
    private func setUIMode(_ enabled:Bool) {
        fromTextField.isEnabled = enabled
        toTextField.isEnabled = enabled
        searchButton.isEnabled = enabled
    }
}

