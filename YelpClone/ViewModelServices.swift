//
//  ViewModelServices.swift
//  YelpClone
//
//  Created by Josh Lehman on 2/12/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation
import UIKit

class ViewModelServices: NSObject {
    
    // MARK: Properties
    let yelpService: YelpService
    
    private let navigationController: UINavigationController
    private var modalNavigationStack: [UINavigationController] = []
    
    // MARK: API
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.yelpService = YelpService(consumerKey: "L0bX77uj12pm1X1moQafxw", consumerSecret: "O0Rp1g1mgc4wfKuBJ3b8W3DKlu4", accessToken: "J1EoSP1l82X32PbTOqKoBXwdszdzXN4s", accessSecret: "pGtXzaceTDQQYWEw6JinPMkI2ds")
    }
    
    // MARK: ViewModelServices Implementation
    
    func pushViewModel(viewModel: AnyObject) {
        if let filtersViewModel = viewModel as? FiltersViewModel {
            modalNavigationStack.push(wrapNavigationController(FiltersViewController(viewModel: filtersViewModel)))
            navigationController.presentViewController(modalNavigationStack.peekAtStack()!, animated: true, completion: nil)
        }
    }
    
    func popActiveModal() {
        let activeModal: UIViewController = modalNavigationStack.pop()!
        activeModal.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Private
    
    private func wrapNavigationController(vc: UIViewController) -> UINavigationController {
        let navC: UINavigationController = UINavigationController(rootViewController: vc)
        navC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        return navC
    }
}