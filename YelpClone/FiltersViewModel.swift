//
//  FiltersViewModel.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/13/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

@objc protocol FiltersViewModelDelegate {
    func filtersViewModelDidCancel(filtersViewModel: FiltersViewModel)
    func filtersViewModelDidComplete(filtersViewModel: FiltersViewModel, yelpFilters: YelpFilters)
}

class FiltersViewModel: NSObject {
    
    // MARK: Properties
    
    var sortFilters: [FilterViewModel]!
    var distanceFilters: [FilterViewModel]!
    var dealsFilter: FilterViewModel!
    var categoriesFilters: [FilterViewModel]!
    var expandCategoriesViewModel: ExpandCategoriesViewModel
    
    weak var delegate: FiltersViewModelDelegate!
    
    private var lessCategories: [FilterViewModel]!
    private let moreCategories: [FilterViewModel]!
    
    private let services: ViewModelServices
    private let yelpFilters: YelpFilters
    private let newYelpFilters: YelpFilters
    
    // MARK: API
    
    init(services: ViewModelServices, yelpFilters: YelpFilters) {
        self.services = services
        self.expandCategoriesViewModel = ExpandCategoriesViewModel(services: services)
        self.yelpFilters = yelpFilters
        self.newYelpFilters = YelpFilters(sort: yelpFilters.sort, categories: yelpFilters.categories, radius: yelpFilters.radius, deals: yelpFilters.deals)
        super.init()
        
        sortFilters = filtersWithGroup([Filter("Best Match", 0), Filter("Distance", 1), Filter("Highest Rated", 2)], group: "sort", canSwitchOff: false, onIndex: newYelpFilters.sort)
        
        // Yuck. TODO: If time, come up with a better implementation of YelpFilters to avoid this mess.
        var distanceFiltersIndex: Int = 0
        let distanceFilterData = [Filter("Best Match", 40000), Filter("2 blocks", 160), Filter("6 blocks", 483), Filter("1 mile", 1609), Filter("5 miles", 8045)]
        for (index: Int, filter: Filter) in enumerate(distanceFilterData) {
            if newYelpFilters.radius == nil {
                break
            } else {
                if newYelpFilters.radius! == filter.value as Int {
                    distanceFiltersIndex = index
                }
            }
        }
        
        distanceFilters = filtersWithGroup(distanceFilterData, group: "distance", canSwitchOff: false, onIndex: distanceFiltersIndex)
        
        dealsFilter = FilterViewModel(services: services, filter: Filter("Has Deals?", nil), on: newYelpFilters.deals ?? false, group: "deals")
        
        // TODO: Compe up with something better?
        lessCategories = filtersWithGroup([Filter("Restaurants", "restaurants"), Filter("Bars", "bars"), Filter("Coffee & Tea", "coffee")], group: "categories")
        moreCategories = lessCategories + filtersWithGroup([Filter("Nightlife", "nightlife"), Filter("Home Services", "homeservices"), Filter("Beauty & Spas", "beautysvc"), Filter("Automotive", "auto")], group: "categories")
        
        for category in moreCategories {
            category.on = false
            for item in newYelpFilters.categories {
                if item as String == category.filter.value as String {
                    category.on = true
                }
            }
        }
        
        categoriesFilters = lessCategories
                
    }
    
    func cancel() {
        if delegate != nil {
            delegate.filtersViewModelDidCancel(self)
        }
    }
    
    func searchWithSettings() {
        if delegate != nil {
            delegate.filtersViewModelDidComplete(self, yelpFilters: self.newYelpFilters)
        }
    }
    
    func toggleExpandCategories() {
        categoriesFilters = expandCategoriesViewModel.expanded ? lessCategories : moreCategories
        expandCategoriesViewModel.expanded = !expandCategoriesViewModel.expanded
    }
    
    func sortFilterChanged(filterViewModel: FilterViewModel) {
        newYelpFilters.sort = filterViewModel.filter.value as? Int
        otherFiltersOff(sortFilters, filterViewModel: filterViewModel)
    }
    
    func distanceFilterChanged(filterViewModel: FilterViewModel) {
        newYelpFilters.radius = filterViewModel.filter.value as? Int
        otherFiltersOff(distanceFilters, filterViewModel: filterViewModel)
    }
    
    func dealsFilterChanged(value: Bool) {
        newYelpFilters.deals = value
    }
    
    func categoriesFiltersChanged(filterViewModel: FilterViewModel) {
        let item = filterViewModel.filter.value as String
        if filterViewModel.on {
            newYelpFilters.categories.addObject(item)
        } else {
            newYelpFilters.categories.minusSet(NSSet(object: item))
        }
        println(newYelpFilters.categories)
    }
    
    // MARK: Private
    
    private func otherFiltersOff(filters: [FilterViewModel], filterViewModel: FilterViewModel) {
        for viewModel in filters {
            if filterViewModel != viewModel {
                viewModel.on = false
            }
        }
    }
    
    private func filtersWithGroup(filters: [Filter], group: String?, canSwitchOff: Bool = true, onIndex: Int? = nil) -> [FilterViewModel] {
        let filters = filters.map { FilterViewModel(services: self.services, filter: $0, on: false, group: group, canSwitchOff: canSwitchOff) }
        if onIndex != nil {
            filters[onIndex!].on = true
        }
        return filters
    }
}