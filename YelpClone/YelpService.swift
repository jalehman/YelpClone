//
//  YelpService.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

typealias JSONParameters = [String: AnyObject]

class YelpService: BDBOAuth1RequestOperationManager {
    
    private let accessToken: String!
    private let accessSecret: String
    
    private let MILES_PER_METER: Double = 0.000621371

    init(consumerKey key: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        var baseUrl = NSURL(string: "http://api.yelp.com/v2/")
        super.init(baseURL: baseUrl, consumerKey: key, consumerSecret: secret)
        var token = BDBOAuthToken(token: accessToken, secret: accessSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchWithTerm(term: String) -> RACSignal {
        var parameters = ["term": term, "ll": "37.774866,-122.394556"]
        return RACSignal.createSignal {
            subscriber -> RACDisposable! in

            self.GET("search", parameters: parameters, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                let responseData = response as JSONParameters
                let businessesJson = responseData["businesses"] as [JSONParameters]
                var searchResults: [SearchResult] = []
                
                for businessJson in businessesJson {
                    let name = businessJson["name"] as String
                    
                    // There may not be an image.
                    var imageURL: NSURL? = nil
                    if let imageURLString = businessJson["image_url"] as? String {
                        imageURL = NSURL(string: imageURLString)
                    }
                    // Address
                    let locationJson = businessJson["location"] as JSONParameters
                    let addressLines = locationJson["address"] as [String]
                    var address: String = ""
                    if addressLines.count == 0 {
                        address = locationJson["city"] as String
                    } else {
                        address = addressLines.first!
                    }
                    var firstNeighborhood: String? = nil
                    if let neighborhoods = locationJson["neighborhoods"] as? [String] {
                        firstNeighborhood = neighborhoods.first
                    }
                    
                    if firstNeighborhood != nil {
                        address = "\(address), \(firstNeighborhood!)"
                    }
                    
                    let rating = businessJson["rating"] as Float
                    let reviewCount = businessJson["review_count"] as Int
                    let distanceMeters = businessJson["distance"] as Double
                    let distanceMiles = distanceMeters * self.MILES_PER_METER
                    let ratingImageURL = NSURL(string: businessJson["rating_img_url_large"] as String)
                    let categoriesJson = businessJson["categories"] as [[String]]
                    let categories: [String] = categoriesJson.map { (cs: [String]) -> String in
                        return cs.first!
                    }
                    
                    searchResults.append(SearchResult(name: name, imageURL: imageURL, address: address, rating: rating, reviewCount: reviewCount, distance: distanceMiles, ratingImageURL: ratingImageURL!, categories: categories))
                }
                
                subscriber.sendNext(searchResults)
                subscriber.sendCompleted()
            }, failure: {
                (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                subscriber.sendError(error)
            })
            
            return nil
        }
    }
}