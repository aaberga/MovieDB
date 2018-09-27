//
//  MovieDetailsCoordinator.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit
import SwiftyJSON


private let kMainStoryBoard = "Main"
private let kMovieDBViewController = "MovieDBViewController"


class MovieDetailsCoordinator: SubCoordinator, MovieDetailsDelegate {
    
    // MARK: Public Properties
    
    var presenter: Coordinator
    var details: [String : Any]?

    var viewController: UIViewController
    var dataService = MoviedDBService()
    
    
    // MARK: Coordinator LifeCycle
    
    init(presenter: Coordinator, targetViewController: UIViewController) {
        
        self.presenter = presenter
        self.viewController = targetViewController
    }
    
    
    // MARK: Public Protocol Interface
    
    func start() {
        
        if let details = self.details {
            
            var movieID = 0
            if let currentMovie = details["targetMovie"] as? Movie {
                
                self.movie = currentMovie
                movieID = Int(currentMovie.id)
            }
            
            if let detailsViewController = self.viewController as? MovieDetailsViewController {
                detailsViewController.delegate = self
            }
            
            if let targetViewController = self.viewController as? MovieDetailsViewController {
                
                self.dataService.getMovieDetails(forMovie: movieID, andOnCompletion: { [weak targetViewController](result: Any?, error: Error?) in
                    
                    DLogWith(message: "Result: \(String(describing: result))")
                    
                    if let json = result as? JSON {
                        
                        let resultString = json.description
                        targetViewController?.displayMovieDetails(resultString)
                    }
                })
            }
        }
    }

    func getMovieInfo() {
        
        if let detailsViewController = self.viewController as? MovieDetailsViewController,
            let movie = self.movie {
            
            let title = movie.title
            let posterImagePath = getTemporaryDirectory().appendingPathComponent(String(movie.posterPath.dropFirst()))
            if let posterData = try? Data(contentsOf: posterImagePath) {
                if let posterImage = UIImage(data: posterData) {
                    detailsViewController.displayMovieInfo(title: title, posterImage: posterImage)
                }
            }
        }
    }
    
    func getMovieDetails() {
    }

    // MARK: Private Properties
    
    private var movie: Movie? = nil
}
