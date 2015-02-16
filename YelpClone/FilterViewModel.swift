//
//  FilterViewModel.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/13/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class FilterViewModel: NSObject {
    
    // MARK: Properties
    
    var filter: Filter
    var group: String?
    let canSwitchOff: Bool
    
    dynamic var on: Bool
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices, filter: Filter, on: Bool, group: String?, canSwitchOff: Bool = true) {
        self.services = services
        self.filter = filter
        self.on = on
        self.canSwitchOff = canSwitchOff
        self.group = group
        super.init()                
    }
}