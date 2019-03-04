//
//  MapViewController.swift
//  Routes
//
//  Created by Vitor Costa on 26/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import UIKit
import MaterialComponents
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photosButton: MDCButton!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Private properties
    private var photosBTScheme:MDCButtonScheme!
    
    // MARK: - Public properties
    var mapResult:MapResult?
    
    // MARK: - View Controller Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        drawRoute()
    }
    
    // MARK: - Private Functions
    private func configureUI() {
        // Configure Navigation Bar
        title = "Map"
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BasePurple")
        
        // Create Configuration Bar Button Item
        let configBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .done, target: self, action: #selector(showConfigurationAlertView))
        self.navigationItem.rightBarButtonItem = configBarButtonItem
        
        // Configure Photos Button
        photosBTScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(photosBTScheme, to: photosButton)
        photosButton.setBackgroundColor(UIColor(named: "BasePurple"))
        
        // Configure Map
        mapView.mapType = DataHelper.shared.getMapTypeSaved() ?? .standard
    }
    
    private func drawRoute() {
        if let route = mapResult?.route,
            let fromAnnotation = mapResult?.from,
            let toAnnotation = mapResult?.to
        {
            mapView.delegate = self
            
            mapView.showAnnotations([fromAnnotation,toAnnotation], animated: true )
            mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveLabels)
            
            let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    private func saveNewMapType(_ type:MKMapType){
        mapView.mapType = type
        DataHelper.shared.setNewMapType(type)
    }
    
    @objc private func showConfigurationAlertView() {
        let alert = UIAlertController(title: "Map Type", message: "Choose the map type to show:", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Hybrid", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.hybrid)
        }))
        
        alert.addAction(UIAlertAction(title: "Hybrid Flyover", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.hybridFlyover)
        }))
        
        alert.addAction(UIAlertAction(title: "Muted Standard", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.mutedStandard)
        }))
        
        alert.addAction(UIAlertAction(title: "Satellite", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.satellite)
        }))
        
        alert.addAction(UIAlertAction(title: "Satellite Flyover", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.satelliteFlyover)
        }))
        
        alert.addAction(UIAlertAction(title: "Standard", style: UIAlertAction.Style.default, handler: { (action) in
            self.saveNewMapType(.standard)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(named: "BasePurple")
        renderer.lineWidth = 2.5
        return renderer
    }
}
