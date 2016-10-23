//
//  Filters.swift
//  Yelper
//
//  Created by YINYEE LAI on 10/22/16.
//  Copyright © 2016 Yin Yee Lai. All rights reserved.
//

import Foundation

@objc class Filters: NSObject {
    enum eDistance:Int {
        case Auto = 0
        case Point3Mile = 483
        case OneMile = 1609
        case FiveMiles = 8047
        case TwentyMiles = 32187
    }
    
    enum eSortBy:Int {
        case BestMatch = 0
        case Distance
        case HighestRated
    }
    
    enum eCategory:String {
        case japanese
        case korean
        case seafood
        case newamerican
    }

    
    var hasDeal: Bool?
    var distance: eDistance?
    var sortBy: eSortBy?
    var categories: [eCategory]?
    
    init(hasDeal: Bool?, distance: eDistance?, sortBy: eSortBy?, categories: [eCategory]?) {
        self.hasDeal = hasDeal
        self.distance = distance
        self.sortBy = sortBy
        self.categories = categories
        
    }
    
    
}
