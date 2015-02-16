//
//  SearchResultsViewModel.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class SearchResultsViewModel: NSObject, FiltersViewModelDelegate {
    
    // MARK: Properties
    
    dynamic var searchResults: [SearchResultViewModel] = []
    dynamic var searchText: String = ""
    
    var yelpFilters: YelpFilters = YelpFilters()
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        
        super.init()
        
        RACObserve(self, "searchText")
            .throttle(0.25)
            .flattenMapAs { [unowned self] (text: NSString) -> RACStream in
                return self.searchYelp(text)
            }.subscribeNext { [unowned self] any in
                let searchResults = any as [SearchResult]
                self.searchResults = searchResults.map { SearchResultViewModel(services: self.services, result: $0) }
        }
    }
    
    func showFilters() {
        let filtersViewModel = FiltersViewModel(services: services, yelpFilters: yelpFilters)
        filtersViewModel.delegate = self
        services.pushViewModel(filtersViewModel)
    }
    
    // MARK: FiltersViewModelDelegate
    
    func filtersViewModelDidCancel(filtersViewModel: FiltersViewModel) {
        services.popActiveModal()
    }
    
    func filtersViewModelDidComplete(filtersViewModel: FiltersViewModel, yelpFilters: YelpFilters) {
        self.yelpFilters = yelpFilters
        services.popActiveModal()
    }
    
    // MARK: Private
    
    private func searchYelp(searchText: String) -> RACSignal {
        return services.yelpService.searchWithTerm(searchText)
    }
}