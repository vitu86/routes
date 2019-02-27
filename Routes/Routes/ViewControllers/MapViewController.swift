//
//  MapViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    // MARK: - Private Functions
    private func configureNavigationBar() {
        title = "Map"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BasePurple")
    }
}
