//
//  ExpandCategoriesViewModel.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/15/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class ExpandCategoriesViewModel: NSObject {
    
    // MARK: Properties
    
    dynamic var expanded: Bool
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        self.expanded = false
    }
}