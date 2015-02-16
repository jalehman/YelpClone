//
//  YelpFilters.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/15/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class YelpFilters: NSObject {
    var sort: Int?
    var categories: NSMutableSet = NSMutableSet()
    var radius: Int?
    var deals: Bool?
    
    init(sort: Int? = nil, categories: NSMutableSet = NSMutableSet(), radius: Int? = nil, deals: Bool? = nil) {
        self.sort = sort
        self.categories = NSMutableSet(set: categories, copyItems: true)
        self.radius = radius
        self.deals = deals
    }
}