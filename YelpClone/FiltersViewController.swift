//
//  FiltersViewController.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/13/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    class func addVFLConstraints(views: [String: UIView], view: UIView, vflConstraints: [String], options: NSLayoutFormatOptions = nil, metrics: [NSObject:AnyObject]? = nil) {
        for vfl in vflConstraints {
            let constraint = NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: options, metrics: metrics, views: views)
            view.addConstraints(constraint)
        }
    }
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FilterTableViewCellDelegate {
    
    // MARK: Properties
    
    // UI Controls
    var cancelButton: UIBarButtonItem!
    var searchButton: UIBarButtonItem!
    var filtersTable: UITableView!
    
    var sortByBestMatchCell: UITableViewCell!
    
    private let viewModel: FiltersViewModel
    
    // MARK: API
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    override func loadView() {
        let contentView = UIView(frame: CGRectZero)
        contentView.backgroundColor = UIColor.blueColor()
        self.view = contentView
        title = "Filters"
        
        filtersTable = UITableView(frame: CGRectZero, style: .Grouped)
        filtersTable.setTranslatesAutoresizingMaskIntoConstraints(false)
        filtersTable.dataSource = self
        filtersTable.delegate = self
        view.addSubview(filtersTable)
        
        let filterNib = UINib(nibName: "FilterTableViewCell", bundle: nil)
        filtersTable.registerNib(filterNib, forCellReuseIdentifier: "filterCell")
        
        let expandCategoriesNib = UINib(nibName: "ExpandCategoriesTableViewCell", bundle: nil)
        filtersTable.registerNib(expandCategoriesNib, forCellReuseIdentifier: "expandCategoriesCell")
        
        let constrainViews: [String: UIView] = ["ftbl": filtersTable]
        NSLayoutConstraint.addVFLConstraints(constrainViews, view: view, vflConstraints: ["V:|[ftbl]|", "H:|[ftbl]|"])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        searchButton = UIBarButtonItem(title: "Search", style: .Bordered, target: self, action: "searchWithSettings:")
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = searchButton
        
        edgesForExtendedLayout = .None
        
        bindViewModel()
    }
    
    // MARK: Actions
    
    func cancel(sender: AnyObject) {
        viewModel.cancel()
    }
    
    func searchWithSettings(sender: AnyObject) {
        viewModel.searchWithSettings()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let expandCategoriesCell = cell as? ExpandCategoriesTableViewCell {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            viewModel.toggleExpandCategories()
            
            /*
            var paths: [NSIndexPath] = []
            for i in [0...viewModel.categoriesFilters.count] {

            }
            */
            
            //tableView.reloadRowsAtIndexPaths([], withRowAnimation: UITableViewRowAnimation.Fade)
            //tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.sortFilters.count
        case 1: return viewModel.distanceFilters.count
        case 2: return 1
        case 3: return viewModel.categoriesFilters.count + 1
        default: fatalError("Unknown section")
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Sort By"
        case 1: return "Distance"
        case 2: return "Deals"
        case 3: return "Categories"
        default: fatalError("Unknown section")
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let item = viewModel.sortFilters[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterTableViewCell
            cell.bindViewModel(item)
            cell.delegate = self
            return cell
        case 1:
            let item = viewModel.distanceFilters[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterTableViewCell
            cell.bindViewModel(item)
            cell.delegate = self
            return cell
        case 2:
            let item = viewModel.dealsFilter
            let cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterTableViewCell
            cell.bindViewModel(item)
            cell.delegate = self
            return cell
        case 3:
            if indexPath.row == viewModel.categoriesFilters.count {
                let cell = tableView.dequeueReusableCellWithIdentifier("expandCategoriesCell") as ExpandCategoriesTableViewCell
                cell.bindViewModel(viewModel.expandCategoriesViewModel)
                return cell
            } else {
                let item = viewModel.categoriesFilters[indexPath.row]
                let cell = tableView.dequeueReusableCellWithIdentifier("filterCell") as FilterTableViewCell
                cell.bindViewModel(item)
                cell.delegate = self
                return cell
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    // MARK: Private
    
    func filterTableViewCell(filterTableViewCell cell: FilterTableViewCell, valueDidChange: Bool, group: String?) {
        if group != nil {
            switch group! {
                case "sort": viewModel.sortFilterChanged(cell.viewModel)
                case "distance": viewModel.distanceFilterChanged(cell.viewModel)
                case "deals": viewModel.dealsFilterChanged(valueDidChange)
                case "categories": viewModel.categoriesFiltersChanged(cell.viewModel)
                default: println("Unrecognized group: \(group!)")
            }
        }
        
    }
    
    private func bindViewModel() {
        //cancelButton.rac_command = viewModel.executeCancel
        //searchButton.rac_command = viewModel.executeCloseFilters
    }
}
