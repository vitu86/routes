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
    
    // MARK: - Private Constants
    private let activeColor:UIColor = UIColor(named: "BasePurple")!

    // MARK: - UIViewController Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - IBActions
    @IBAction func searchButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToMap", sender: nil)
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
}

