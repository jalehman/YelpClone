//
//  SearchResultViewModel.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class SearchResultViewModel: NSObject {
    
    // MARK: Properties
    
    let name: String
    let imageURL: NSURL?
    let address: String
    let rating: Float
    let reviewCount: Int
    let distance: Double
    let ratingImageURL: NSURL?
    let categories: [String]
    let result: SearchResult
    
    private let services: ViewModelServices
    
    init(services: ViewModelServices, result: SearchResult) {
        self.services = services
        self.name = result.name
        self.imageURL = result.imageURL
        self.address = result.address
        self.rating = result.rating
        self.reviewCount = result.reviewCount
        self.distance = result.distance
        self.ratingImageURL = result.ratingImageURL
        self.categories = result.categories
        self.result = result
    }
}