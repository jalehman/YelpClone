//
//  SearchResult.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class SearchResult: NSObject {
    
    // MARK: Properties
    
    let name: String
    let imageURL: NSURL?
    let address: String
    let rating: Float
    let reviewCount: Int
    let distance: Double
    let ratingImageURL: NSURL?
    let categories: [String]
    
    init(name: String, imageURL: NSURL?, address: String, rating: Float, reviewCount: Int, distance: Double, ratingImageURL: NSURL?, categories: [String]) {
        self.name = name
        self.imageURL = imageURL
        self.address = address
        self.rating = rating
        self.reviewCount = reviewCount
        self.distance = distance
        self.ratingImageURL = ratingImageURL
        self.categories = categories
    }    
    
}