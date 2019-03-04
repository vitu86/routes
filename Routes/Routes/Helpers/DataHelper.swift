//
//  DataHelper.swift
//  Routes
//
//  Created by Vitor Costa on 04/03/19.
//  Copyright © 2019 Vitor Costa. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class DataHelper {
    // MARK: - STATIC OBJECT REFERENCE
    static let shared:DataHelper = DataHelper()
    
    // MARK: - Private constants
    private let mapTypeValueKey:String = "MapTypeValueKey"
    
    // private init for override purpose
    private init() {
    }
    
    // MARK: - UserDefaults Functions
    func setNewMapType(_ type:MKMapType) {
        UserDefaults.standard.set(NSNumber(value: type.rawValue), forKey: mapTypeValueKey)
    }
    
    func getMapTypeSaved() -> MKMapType? {
        if let recordedMapType = UserDefaults.standard.object(forKey: mapTypeValueKey) as? NSNumber,
            let mapTypeCasted = MKMapType(rawValue: recordedMapType.uintValue) {
            return mapTypeCasted
        } else {
            return nil
        }
    }
    
    // MARK: - Search Core Data Functions
    func getSearchData() -> NSFetchedResultsController<Search> {
        return CoreDataHelper.shared.getFetchedResultsControllerOfSearchs()
    }
    
    func deleteSearch(_ search:Search) {
        CoreDataHelper.shared.deleteSearch(search)
    }
}
