//
//  MovieCollectionCoordinator.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 26/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


struct MovieCollectionCoordinator: Coordinator {
    
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
