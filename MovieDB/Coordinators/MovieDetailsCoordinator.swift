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
            
            if let currentMovie = details["targetMovie"] as? Movie {
                
                self.movie = currentMovie
            }
            
            if let detailsViewController = self.viewController as? MovieDetailsViewController {
                detailsViewController.delegate = self
            }
            
            self.getMovieDetails()
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
        
        if let detailsViewController = self.viewController as? MovieDetailsViewController,
            let movie = self.movie  {
            
            let movieID = Int(movie.id)

            self.dataService.getMovieDetails(forMovie: movieID, andOnCompletion: { [weak detailsViewController](result: Any?, error: Error?) in
                
//                DLogWith(message: "Result: \(String(describing: result))")
                
                if let json = result as? JSON {
                    
                    if let movieDetails = json.dictionary {
                        
                        let title = movieDetails["original_title"]?.string
                        let overview = movieDetails["overview"]?.string
                        var genresList = ""
                        if let rawGenres = movieDetails["genres"]?.array {
                            for currentGenreInfo in rawGenres {
                                
                                if let currentGenreInfo = currentGenreInfo.dictionary {
                                    if let newGenre = currentGenreInfo["name"]?.string {
                                        if genresList == "" {
                                            genresList = newGenre
                                        } else {
                                            genresList = genresList + ", " + newGenre
                                        }
                                    }
                                }
                            }
                        }
                        let relaseDate = movieDetails["release_date"]?.string
                        let imdbRef = movieDetails["imdb_id"]?.string
                        let homepage = movieDetails["homepage"]?.string
                        
                        if let title = title, let overview = overview, let relaseDate = relaseDate, let imdbRef = imdbRef, let homepage = homepage {
                            let resultString = """
                            Original Title:\t\(title)
                            
                            Overview:\t\(overview)
                            
                            Genres:
                            \(genresList)
                            
                            Release Date:
                            \(relaseDate)
                            
                            IMDB:\t\(imdbRef)
                            
                            Homepage:
                            \(homepage)
                            """
                            
                            detailsViewController?.displayMovieDetails(resultString)
                        }
                        
                        if let movieCollection = movieDetails["belongs_to_collection"]?.dictionary {
                            
//                            DLogWith(message: "Collection: \(movieCollection)")
                            if let belongingCollection = movieCollection["id"] {
                                
                                if let collectionID = belongingCollection.int   {
                                    self.getMovieCollectionData(for: collectionID)
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    func getMovieCollectionData(for collectionID: Int) {
        
        DLogWith(message: "Look up collection '\(collectionID)'\n")
        
        if let detailsViewController = self.viewController as? MovieDetailsViewController {
            
            self.dataService.getMoviesInCollection(withID: collectionID, andOnCompletion: { [weak detailsViewController] (result: Any?, error: Error?) in
                
                DLogWith(message: "VC: \(String(describing: detailsViewController))")
                if let result = result as? MovieCollection {
                    
                    DLogWith(message: "Collection Movies: \(result)")
                    
                }
            })
        }
    }

    // MARK: Private Properties
    
    private var movie: Movie? = nil
    private var relatedMovieCollection: MovieCollection? = nil
}
