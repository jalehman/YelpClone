//
//  SearchResultTableViewCell.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell, ReactiveView {
    
    // MARK: Properties
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var numReviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImage.layer.cornerRadius = 3.0
        thumbnailImage.clipsToBounds = true
        placeNameLabel.preferredMaxLayoutWidth = placeNameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeNameLabel.preferredMaxLayoutWidth = placeNameLabel.frame.size.width
    }

    func bindViewModel(viewModel: AnyObject) {
        let viewModel = viewModel as SearchResultViewModel
        placeNameLabel.text = viewModel.name
        if viewModel.imageURL != nil {
            thumbnailImage.setImageWithURL(viewModel.imageURL!)
        }
        
        if viewModel.ratingImageURL != nil {
            ratingImage.setImageWithURL(viewModel.ratingImageURL!)
        }
        
        numReviewsLabel.text = "\(viewModel.reviewCount) Reviews"
        addressLabel.text = viewModel.address
        categoriesLabel.text = ", ".join(viewModel.categories)
        distanceLabel.text = NSString(format: "%.2f mi", viewModel.distance)
    }
    
}
