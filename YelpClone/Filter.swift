//
//  Filter.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

struct Filter {
    let label: String
    let value: AnyObject!
    
    init(_ label: String, _ value: AnyObject!) {
        self.label = label
        self.value = value
    }
}