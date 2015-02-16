//
//  ExpandCategoriesTableViewCell.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/14/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ExpandCategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var directionToExpandLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bindViewModel(viewModel: AnyObject) {
        let expandCategoriesViewModel = viewModel as ExpandCategoriesViewModel
        
        RACObserve(expandCategoriesViewModel, "expanded").takeUntil(rac_prepareForReuseSignal).subscribeNextAs {
            [unowned self] (expanded: NSNumber) in
            self.directionToExpandLabel.text = expanded.boolValue ? "Show Less" : "Show More"
        }
    }
}
