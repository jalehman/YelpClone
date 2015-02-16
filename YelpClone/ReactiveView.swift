//
//  ReactiveView.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

@objc protocol ReactiveView {
    func bindViewModel(viewModel: AnyObject)
}