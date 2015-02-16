//
//  SearchResultsViewController.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var resultsTable: UITableView!
    
    private var filterButton: UIBarButtonItem!
    private let searchBar: UISearchBar = UISearchBar()
    private let viewModel: SearchResultsViewModel
    
    // MARK: API
    
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SearchResultsViewController", bundle: nil)        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTable.dataSource = self
        searchBar.delegate = self
        
        searchBar.placeholder = "Search Yelp"
        
        filterButton = UIBarButtonItem(title: "Filters", style: .Bordered, target: self, action: "showFilters:")
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        resultsTable.registerNib(nib, forCellReuseIdentifier: "searchResultCell")
        resultsTable.rowHeight = UITableViewAutomaticDimension
        
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = filterButton
        
        edgesForExtendedLayout = .None
        
        bindViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsUpdateConstraints()
        resultsTable.reloadData()
    }
    
    // This might be the right way to update the constraints when the orientation changes? Not sure.
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.view.setNeedsUpdateConstraints()
        resultsTable.reloadData()
    }
    
    
    
    func showFilters(sender: AnyObject) {
        viewModel.showFilters()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.searchResults[indexPath.row]
        let cell = resultsTable.dequeueReusableCellWithIdentifier("searchResultCell") as SearchResultTableViewCell
        
        cell.bindViewModel(cellViewModel)
        
        return cell
    }
    
    // MARK: Private
    
    func bindViewModel() {
        let searchSignal = rac_signalForSelector("searchBar:textDidChange:", fromProtocol: UISearchBarDelegate.self)
        
        RAC(viewModel, "searchText") << searchSignal.mapAs {
            (tuple: RACTuple) -> NSString in
            return tuple.second as NSString
        }
        
        RACObserve(viewModel, "searchResults")
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext {
            _ in
            self.resultsTable.reloadData()
        }
        
        let loadingSignal = RACObserve(viewModel, "loading")
        var hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.textLabel.text = "Loading"
        
        loadingSignal.filter { return $0.boolValue }.subscribeNext {
            [unowned self] _ in
            hud.showInView(self.view)
        }
        
        loadingSignal.filter { return !$0.boolValue }.subscribeNext {
            _ in
            hud.dismiss()
        }
    }
    
}
