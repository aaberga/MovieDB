//
//  MovieDetailsCoordinator.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


struct MovieDetailsCoordinator: Coordinator {

    // MARK: Public Properties
    
    var viewController: UIViewController
    var dataService = MoviedDBService()
    
    
    // MARK: Coordinator LifeCycle
    
    init(targetViewController: UIViewController) {
        
        self.viewController = targetViewController
    }
    
    
    // MARK: Public Protocol Interface
    
    func start() {
    }
    
    
}
