//
//  MapHelper.swift
//  Routes
//
//  Created by Vitor Costa on 27/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import MapKit

class MapHelper {
    
    // MARK: STATIC OBJECT REFERENCE
    static let sharedInstance:MapHelper = MapHelper()
    
    // private init for override purpose
    private init() {
    }
    
    func getMapResultFromAddresses(from:String, to:String, onComplete: @escaping (MapResult) -> Void) {
        var result:MapResult = MapResult()
        
        // Get CLPlacemarks from geocode using strings
        translateStringsToCLPlacemarks(from: from, to: to) { (fromPM, toPM, errorMessage) in
            if let errorMessage = errorMessage {
                // Return error if cant find locations
                result.errorMessage = errorMessage
                onComplete(result)
            } else {
                if let from = fromPM, let to = toPM {
                    // Get MKAnnotations and MKRoute from CLPlaceMarks
                    self.translateCLPlacemarksToRouteAndAnnotations(fromPM: from, toPM: to, onComplete: { (fromMK, toMK, routeMK, error) in
                        if let error = error {
                            // Return error if cant trace route
                            result.errorMessage = error
                            onComplete(result)
                        } else {
                            if let fromMK = fromMK, let toMK = toMK, let routeMK = routeMK {
                                // Return all data
                                result.from = fromMK
                                result.to = toMK
                                result.route = routeMK
                                onComplete(result)
                            } else {
                                // Return error in if let
                                result.errorMessage = "Could not load map annotations."
                                onComplete(result)
                            }
                        }
                    })
                } else {
                    // Return error in if let
                    result.errorMessage = "Could not load locations."
                    onComplete(result)
                }
            }
        }
    }
    
    private func translateStringsToCLPlacemarks(
        from:String,
        to:String,
        onComplete: @escaping (CLPlacemark?, CLPlacemark?, String?) -> Void
        )
    {
        // Processing properties
        var processedStrings:Int = 0
        var stringsWithError:[String] = []
        var fromPM:CLPlacemark?
        var toPM:CLPlacemark?
        
        // Subfunction to validate async answer of geocode
        func checkCompletion() {
            processedStrings += 1
            if processedStrings == 2 {
                if !stringsWithError.isEmpty {
                    var errorMessage = "Could not get locations from: "
                    for item in stringsWithError {
                        errorMessage += item + ", "
                    }
                    errorMessage.removeLast(2)
                    errorMessage += "."
                    onComplete(nil, nil, errorMessage)
                } else {
                    onComplete(fromPM, toPM, nil)
                }
            }
        }
        
        // Subfunction to handler translate string to location function
        func handlerAnswer(markers:[CLPlacemark]?, isFromAddress:Bool) {
            if let markers = markers {
                if markers.count <= 0 {
                    // If there's no locations, add to strings with error.
                    stringsWithError.append(isFromAddress ? from : to)
                } else {
                    // If there's any location, associate to property
                    if isFromAddress {
                        fromPM = markers[0]
                    } else {
                        toPM = markers[0]
                    }
                }
            } else {
                // If got some error, add to strings with error.
                stringsWithError.append(isFromAddress ? from : to)
            }
            checkCompletion()
        }
        
        // Subfunction to translate string address to geopoints location as PlaceMark.
        func translateStringToGeoPoints(string:String, onComplete:@escaping ([CLPlacemark]?) -> Void) {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(string) { (markers, error) in
                if error == nil {
                    onComplete(markers)
                } else {
                    onComplete(nil)
                }
            }
        }
        
        translateStringToGeoPoints(string: from) { (markers) in
            handlerAnswer(markers: markers, isFromAddress: true)
        }
        translateStringToGeoPoints(string: to) { (markers) in
            handlerAnswer(markers: markers, isFromAddress: false)
        }
    }
    
    private func translateCLPlacemarksToRouteAndAnnotations(
        fromPM:CLPlacemark,
        toPM:CLPlacemark,
        onComplete: @escaping (MKAnnotation?, MKAnnotation?, MKRoute?, String?) -> Void
        )
    {
        
        // This function was based on this solution:
        // https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial
        
        // Processing properties
        let fromMKP:MKPlacemark = MKPlacemark(placemark: fromPM)
        let toMKP:MKPlacemark = MKPlacemark(placemark: toPM)
        
        // Result properties
        let fromAnnotation = MKPointAnnotation()
        let toAnnotation = MKPointAnnotation()
        
        if let fromTitle = fromMKP.title, let toTitle = toMKP.title {
            fromAnnotation.title = fromTitle
            fromAnnotation.coordinate = fromMKP.coordinate
            
            toAnnotation.title = toTitle
            toAnnotation.coordinate = toMKP.coordinate
        } else {
            onComplete(nil, nil, nil, "Could not load map annotations")
            return
        }
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: fromMKP)
        directionRequest.destination = MKMapItem(placemark: toMKP)
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            if let response = response {
                let route = response.routes[0]
                onComplete(fromAnnotation, toAnnotation, route, nil)
            } else {
                onComplete(nil, nil, nil, "Could not load route.")
            }
        }
    }
}
