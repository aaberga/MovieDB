//
//  NowPlayingCoordinator.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


class NowPlayingCoordinator: NSObject, Coordinator {

    // MARK: Public Properties

    var viewController: UIViewController
    var dataService = MoviedDBService()

    
    // MARK: Coordinator LifeCycle
    
    init(targetViewController: UIViewController) {
        
        self.viewController = targetViewController
    }

    
    // MARK: Public Protocol Interface
    
    func start() {
        
        if let viewController = self.viewController as? MovieDBViewController {
            
            viewController.delegate = self
            self.getMoviesPlayingNow()
        }
    }
    
    // MARK: Private Properties
    
    private var playingMovies: PlayingMoviesResponse?
    private var currentError: Error?

    private let detailsCoordinator: MovieDetailsCoordinator? = nil
    private let collectionCoordinator: MovieCollectionCoordinator? = nil
}


extension NowPlayingCoordinator: NowPlayingMoviesDelegate {
    
    func getMoviesPlayingNow() {

        self.dataService.getMoviesNowPlaying(withCompletion: { result, error in
            
            self.displayServiceOutcome(result, error)
        })
    }
}


extension NowPlayingCoordinator {

    func displayServiceOutcome(_ result: Any?, _ error: Error?) -> Void {

        if let obtainedMovies = result as? PlayingMoviesResponse {

            if let viewController = self.viewController as? MovieDBViewController {

//                DLogWith(message: "Weather Data: \(result)")

                self.playingMovies = obtainedMovies
                self.currentError = nil

                DispatchQueue.main.async {

                    viewController.displayMovies(from: self, with: self)
                }
            }

        } else if let error = error {

            if let viewController = self.viewController as? MovieDBViewController {

//                DLogWith(message: "Error Data: \(error.localizedDescription)")
                self.playingMovies = nil
                self.currentError = error

                DispatchQueue.main.async {

                    viewController.displayMovies(from: self, with: self)
                }
            }
        }
    }
}


// MARK: - Table View DataSource

extension NowPlayingCoordinator: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let playingMovies = self.playingMovies {
            
            let playingMovies = playingMovies.movies.count
            
            return playingMovies + 1
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!

        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath)
        
        return cell
    }
}

// MARK: - Table View Delegate

extension NowPlayingCoordinator: UICollectionViewDelegate {
    
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let indexPath = tableView.indexPathForSelectedRow
     let currentCell = tableView.cellForRow(at: indexPath!)!
     print(currentCell.textLabel!.text!)
     }
     */
}
