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
        
        // Configure Photos Button
        photosBTScheme = MDCButtonScheme()
        MDCContainedButtonThemer.applyScheme(photosBTScheme, to: photosButton)
        photosButton.setBackgroundColor(UIColor(named: "BasePurple"))
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
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(named: "BasePurple")
        renderer.lineWidth = 2.5
        return renderer
    }
}
