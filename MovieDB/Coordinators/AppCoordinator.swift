//
//  AppCoordinator.swift
//  Weather 5D
//
//  Created by Aldo Bergamini on 19/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


private let kMovieDBAPIToken = "3eb5f4eddc9e7368b2f6341a42bb04f1"
private let kMainStoryBoard = "Main"
private let kNavigationController = "NavigationController"
private let kMovieDBViewController = "MovieDBViewController"




class AppCoordinator: Coordinator {
    
    // MARK: Coordinator Properties
    
    var viewController: UIViewController {
        
        get {
            if let navigationController = self.rootController {
                
                return navigationController
                
            } else {
                let storyboard = UIStoryboard(name: kMainStoryBoard, bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: kNavigationController)
                return controller
            }
        }
        
        set(viewController) {
            self.rootController = viewController as? UINavigationController
        }
    }
    
    
    // MARK: Coordinator Methods
    
    func start() {
        
        let storyboard = UIStoryboard(name: kMainStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: kMovieDBViewController)

        self.nowPlayingMoviesCoordinator = NowPlayingCoordinator(targetViewController: controller)
        self.rootController?.pushViewController(controller, animated: false)
        
        self.nowPlayingMoviesCoordinator?.start()
    }
  
    
    // MARK: Coordinator LifeCycle

    init(targetViewController: UIViewController) {
        
        self.viewController = targetViewController
    }
    
    
    // MARK: Private Properties
    
    var rootController: UINavigationController?
    var nowPlayingMoviesCoordinator: NowPlayingCoordinator?
}
