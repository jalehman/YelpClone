//
//  FilterTableViewCell.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/13/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

@objc protocol FilterTableViewCellDelegate {
    func filterTableViewCell(filterTableViewCell cell: FilterTableViewCell, valueDidChange: Bool, group: String?)
}

class FilterTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterSwitch: UISwitch!
    
    var viewModel: FilterViewModel!
    weak var delegate: FilterTableViewCellDelegate!
    
    // MARK: UITableViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
    
    
    // MARK: API
    
    func bindViewModel(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        filterLabel.text = viewModel.filter.label
        
        // Need to set this originally so that newly reused cells start enabled.
        filterSwitch.enabled = true

        let switchChangedSignal = filterSwitch.rac_newOnChannel().takeUntil(self.rac_prepareForReuseSignal)
        let viewModelChangedSignal = RACObserve(viewModel, "on").distinctUntilChanged().takeUntil(self.rac_prepareForReuseSignal)

        // Establish a two-way binding
        // Note: Can't use the RAC macro because the bindings won't be disposed of properly on reuse
        switchChangedSignal.subscribeNextAs {
            [unowned self] (on: NSNumber) in
            self.viewModel.on = on.boolValue
        }
        
        viewModelChangedSignal.subscribeNextAs {
            [unowned self] (on: NSNumber) in
            self.filterSwitch.on = on.boolValue
        }
        
        viewModelChangedSignal.filter { _ -> Bool in !viewModel.canSwitchOff }
            .subscribeNextAs { [unowned self] (on: NSNumber) in
                self.filterSwitch.enabled = !on.boolValue
        }
        
        switchChangedSignal.subscribeNextAs {
            [unowned self] (on: NSNumber) in
            
            if self.delegate != nil {
                self.delegate.filterTableViewCell(filterTableViewCell: self, valueDidChange: on.boolValue, group: viewModel.group)
            }
        }
    }
    
}
