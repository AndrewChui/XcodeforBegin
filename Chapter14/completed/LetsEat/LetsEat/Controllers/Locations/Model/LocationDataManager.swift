//
//  LocationDataManager.swift
//  LetsEat
//
//  Created by Craig Clayton on 7/18/17.
//  Copyright © 2017 Cocoa Academy. All rights reserved.
//

import Foundation

class LocationDataManager {
    
    private var locations:[String] = []
    
    init() {
        fetch()
    }
    
    func fetch() {
        for location in loadData() {
            if let city = location["city"] as? String,
                let state = location["state"] as? String {
                locations.append("\(city), \(state)")
            }
        }
    }
    
    func numberOfItems() -> Int {
        return locations.count
    }
    
    func locationItem(at index:IndexPath) -> String {
        return locations[index.item]
    }
    
    private func loadData() -> [[String: AnyObject]] {
        guard let path = Bundle.main.path(forResource: "Locations", ofType: "plist"), let items = NSArray(contentsOfFile: path) else {
            return [[:]]
        }
        return items as! [[String : AnyObject]]
    }
}
