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
    
    dynamic var yelpFilters: YelpFilters = YelpFilters()
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        
        super.init()
        
        let searchTextChangedSignal = RACObserve(self, "searchText")
        let filtersChangedSignal = RACObserve(self, "yelpFilters")
        
        let combinedSignal = RACSignal.merge([searchTextChangedSignal, filtersChangedSignal])
        
        combinedSignal.throttle(0.25)
            .flattenMap { [unowned self] _ -> RACStream in
                return self.searchYelp()
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
        services.yelpService.searchWithTerm(searchText, filters: yelpFilters)
        services.popActiveModal()
    }
    
    // MARK: Private
    
    private func searchYelp() -> RACSignal {
        return services.yelpService.searchWithTerm(self.searchText, filters: yelpFilters)
    }
}