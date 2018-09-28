//
//  NowPlayingCoordinator.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit
import SwiftyJSON

private let kMainStoryBoard = "Main"
private let kMovieDetailsViewController = "MovieDetailsViewController"


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

    private var detailsCoordinator: MovieDetailsCoordinator? = nil
    private var collectionCoordinator: MovieCollectionCoordinator? = nil
}


extension NowPlayingCoordinator: NowPlayingMoviesDelegate {
    
    func getMoviesPlayingNow() {

        self.dataService.getMoviesNowPlaying(withCompletion: { result, error in
            
            self.displayServiceOutcome(result, error)
        })
    }
    
    func getMoviePosters(for moviesList: [Movie]) {
        
//        var oneList: [Movie] = []
//        if let firstOne = moviesList.first {
//            oneList.append(firstOne)
//        }
//
        //moviesList
        for currentMovie in moviesList {
            
            let imageID = String(currentMovie.posterPath.dropFirst())
            DispatchQueue.global(qos: .background).async {
                self.getMoviesPoster(withImageID: imageID)
            }
        }
    }
    
    func getMoviesPoster(withImageID imageID: String) {
        
        self.dataService.getMoviePoster(with: imageID, andOnCompletion: { result, error in
            
            self.displayMoviePoster(result, error)
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
                
                self.getMoviePosters(for: obtainedMovies.movies)
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
    
    func displayMoviePoster(_ result: Any?, _ error: Error?) -> Void {
    
        if let posterData = result as? [String: Any] {
            
//            DLogWith(message: "Data: \(posterData)")
            let image = posterData["image"] as? UIImage
            let imageID = posterData["imageID"] as? String

            if let image = image, let imageID = imageID {
                
//                DLogWith(message: "imageID: \(imageID)")
//                DLogWith(message: "imageData: \(image)")
                
                if let data = image.jpegData(compressionQuality: 100) {
                    
                    let filename = getTemporaryDirectory().appendingPathComponent(imageID)
//                    DLogWith(message: "Temp Image file: \(filename)")
                    try? data.write(to: filename)
                    
                    if let viewController = self.viewController as? MovieDBViewController {
                        
                        DispatchQueue.main.async {
                            viewController.displayMovies(from: self, with: self)
                        }
                    }
                }

            }
            
        } else {
            
            if let error = error {
                DLogWith(message: "Error: \(error)")
            }
        }
    }
}


// MARK: - Table View DataSource

extension NowPlayingCoordinator: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if let playingMovies = self.playingMovies {
            
            let playingMovies = playingMovies.movies.count
            return playingMovies
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var cell: UICollectionViewCell!

        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath)
        if let titleLabel = cell.viewWithTag(101) as? UILabel,
            let posterImageView = cell.viewWithTag(100) as? UIImageView {
            
            titleLabel.text = "N/A"
            posterImageView.image = nil
            
//            DLogWith(message: "Index: \(indexPath.row)")
            if let targetMovie = self.playingMovies?.movies[indexPath.row] {
                
                titleLabel.text = targetMovie.title
                let imageFileName = String(targetMovie.posterPath.dropFirst())
                let tempImagePath = getTemporaryDirectory().appendingPathComponent(imageFileName)
                do {
                    let imageData = try  Data(contentsOf: tempImagePath)
                    //                DLogWith(message: "tempImage: \(tempImagePath)")
                    if let posterImage = UIImage(data: imageData) {
                        posterImageView.image = posterImage
                    } else {
                        DLogWith(message: "Could not load image \(imageFileName)")// @ \(tempImagePath)")
                    }
                } catch let error {
                    
                    DLogWith(message: "Error: \(error)")
                }
            }
        }
        return cell
    }
}


// MARK: - Table View Delegate

extension NowPlayingCoordinator: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            
//            let currentCell = collectionView.cellForItem(at: indexPath)!
            
            if let selectedMovie = self.playingMovies?.movies[indexPath.row] {

//                DLogWith(message: "\(selectedMovie.title)")
                self.showMovieDetailsScreen(for: selectedMovie)
            }
        }
    }
}


// MARK: Detail / Navigation Extension

extension NowPlayingCoordinator {
    
    func showMovieDetailsScreen(for movie: Movie) {
        
        let storyboard = UIStoryboard(name: kMainStoryBoard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: kMovieDetailsViewController)
        
        let movieDetailsCoordinator = MovieDetailsCoordinator(presenter: self, targetViewController: controller)
        self.detailsCoordinator = movieDetailsCoordinator
        movieDetailsCoordinator.details = ["targetMovie": movie]
        
        if let presenter = self.viewController.parent as? UINavigationController {
            
            presenter.pushViewController(controller, animated: true)
            movieDetailsCoordinator.start()
        }
    }
}
