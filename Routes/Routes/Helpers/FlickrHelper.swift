//
//  FlickrHelper.swift
//  Routes
//
//  Created by Vitor Costa on 04/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import MapKit

class FlickrHelper {
    
    // MARK: STATIC OBJECT REFERENCE
    static let shared:FlickrHelper = FlickrHelper()
    
    // MARK: Private properties and constants
    private let flickrApiKey:String = "36d4bbc25bbadefaeaae521e88642e9a"
    private var resultList:[String] = []
    private var returnFunction: (([String]) -> Void)!
    private var stepsProcessed:Int = 0
    private var stepsToProccess:Int = 0
    
    // private init for override purpose
    private init() {
    }
    
    func getImagesFromRoute(route:MKRoute, onComplete: @escaping ([String]) -> Void) {
        resultList = []
        returnFunction = onComplete
        stepsProcessed = 0
        stepsToProccess = route.steps.count
        for step in route.steps {
            getPhotoList(step)
        }
    }
    
    private func getPhotoList(_ step:MKRoute.Step) {
        let getPhotoListURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrApiKey)&lat=\(step.polyline.coordinate.latitude)&lon=\(step.polyline.coordinate.longitude)&extras=url_q&per_page=1&format=json&nojsoncallback=1"
        let request = NSMutableURLRequest(url: URL(string: getPhotoListURL)!)
        let session = URLSession.shared
        
        let getPhotoListTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                self.checkReturn()
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                let photoList = json["photos"] as? [String:Any] ?? [:]
                let photos = photoList["photo"] as? [[String:Any]]
                if let photos = photos {
                    if photos.count > 0 {
                        if let url = photos[0]["url_q"] as? String {
                            if !self.resultList.contains(url) {
                                self.resultList.append(url)
                            }
                        }
                    }
                }
            } catch let err as NSError {
                print(err)
            }
            self.checkReturn()
        }
        getPhotoListTask.resume()
    }
    
    private func checkReturn() {
        stepsProcessed += 1
        if stepsProcessed >= stepsToProccess {
            returnFunction(resultList)
        }
    }
}
