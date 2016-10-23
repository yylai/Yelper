//
//  Filters.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/22/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import Foundation

@objc class Filters: NSObject {
    enum eDistance {
        case Auto
        case Point3
        case One
        case Five
        case Twenty
    }
    
    enum eSortBy {
        case BestMatch
        case Distance
        case HighestRated
    }
    
    enum eCategory {
        case Japanese
        case Korean
        case Seafood
        case NewAmerican
        //["name" : "American, New", "code": "newamerican"],
    }

    
    let hasDeal: Bool?
    let distance: eDistance?
    let sortBy: eSortBy?
    let categories: [eCategory]?
    
    init(hasDeal: Bool, distance: eDistance, sortBy: eSortBy, categories: [eCategory]) {
        self.hasDeal = hasDeal
        self.distance = distance
        self.sortBy = sortBy
        self.categories = categories
        
    }
    
    
}
