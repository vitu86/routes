//
//  MapViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import MaterialComponents

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photosButton: MDCButton!
    
    // MARK: - Private properties
    private var photosBTScheme:MDCButtonScheme!
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure Navigation Bar
        title = "Map"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BasePurple")
        
        // Configure Photos Button
        photosBTScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(photosBTScheme, to: photosButton)
        photosButton.setBackgroundColor(UIColor(named: "BasePurple"))
    }
}
