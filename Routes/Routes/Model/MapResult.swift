//
//  MapResult.swift
//  Routes
//
//  Created by Vitor Costa on 27/02/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import MapKit

struct MapResult {
    var from:MKAnnotation?
    var to:MKAnnotation?
    var route:MKRoute?
    var errorMessage:String?
}
