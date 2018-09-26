//
//  MovieDBService.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation
import SwiftyJSON


private let kMovieDB_APIKey = "73bc7e190c9dfe6e7be35a5d11e44949"
private let kErrorDomain = "MovieDB"


enum MDBRequestType: String {
    
    case moviesNowPlaying
    case movieDetails
    case moviesInCollection
}


enum MDBRequestParameter: String {
    
    case movieID
    case collectionID
    case api
}



class MoviedDBService: DataService {
    
    // MARK: Properties
    
    //  // No Props
    
    // MARK: Generic Service Interface
    
    func obtainEntityFor(key: String, withParameters passedData: [String: Any]?, andOnCompletion completionBlock: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        
        switch key {
            
        case MDBRequestType.moviesNowPlaying.rawValue:
            break
            
            
        case MDBRequestType.movieDetails.rawValue:
            break

            
        case MDBRequestType.moviesInCollection.rawValue:
            break
            
            
        default:
            let parametersError: NSError? = NSError(domain: kErrorDomain, code: 1001, userInfo: ["ErrorString": "Wrong API Request In API Call"])
            completionBlock(nil, parametersError)
        }
    }

    // MARK: Specific OWM Service Interface
    
    func getMoviesNowPlaying(withCompletion completionBlock: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        
        func transformResponseToModel(_ result: Any?, _ error: Error?) -> Void {
            
            var nowPlayingResponse: PlayingMoviesResponse?
            var moviesList: [Movie]?
            
            /*
             
             let movies: [Movie]
             
             let page: Int
             
             let totalPages: Int
             let totalMovies: Int
             */
            
            var apiError: NSError?

            if let nowPlayingMovies = result as? JSON {
                
                DLogWith(message: "Now Playing: \(nowPlayingMovies)")
                let totalResults = nowPlayingMovies["total_results"].int
                let totalPages = nowPlayingMovies["total_pages"].int
                let currentPage = nowPlayingMovies["page"].int
                
                if let totalResults = totalResults, let totalPages = totalPages, let currentPage = currentPage {
 
                    if let moviesDataList = nowPlayingMovies["results"].array {
                        
                        var foundMoviesList: [Movie] = []

                        for currentMovieData in moviesDataList {
                            
                            let id = currentMovieData["id"].int
                            let title = currentMovieData["title"].string
                            let releaseDate = currentMovieData["release_date"].string

                            let overview = currentMovieData["overview"].string
                            let originalTitle = currentMovieData["original_title"].string
                            let originalLanguage = currentMovieData["original_language"].string
                            
                            let posterPath = currentMovieData["poster_path"].string
                            
                            if let id = id, let title = title, let releaseDate = releaseDate, let overview = overview, let originalTitle = originalTitle,
                                let originalLanguage = originalLanguage, let posterPath = posterPath {
                                
                                let newMovie = Movie(id: id, title: title, releaseDate: releaseDate, overview: overview, originalTitle: originalTitle, originalLanguage: originalLanguage, posterPath: posterPath)
                                foundMoviesList.append(newMovie)
                            }
                        }
                        moviesList = foundMoviesList
                            
                        nowPlayingResponse = PlayingMoviesResponse(movies: moviesList!, page: currentPage, totalPages: totalPages, totalMovies: totalResults)
                        completionBlock(nowPlayingResponse, apiError)
                        
                    } else {
                        
                        let responseError: NSError? = NSError(domain: kErrorDomain, code: 1002, userInfo: ["ErrorString": "No forecast points! \(String(describing: result))"])
                        apiError = responseError
                        DLogWith(message: "Error: \(apiError!)")
                    }
                    
                } else {
                    
                    let responseError: NSError? = NSError(domain: kErrorDomain, code: 1001, userInfo: ["ErrorString": "No forecast points! \(String(describing: result))"])
                    apiError = responseError
                    DLogWith(message: "Error: \(apiError!)")
                }
            } else {
                
                let responseError: NSError? = NSError(domain: kErrorDomain, code: 1000, userInfo: ["ErrorString": "No forecast points! \(String(describing: result))"])
                apiError = responseError
                DLogWith(message: "Error: \(apiError!)")
            }
            
            if let apiError = apiError {
                
                DLogWith(message: "Error: \(apiError)")
                completionBlock(nil, apiError)
            }
        }
        
        MovieDB_MoviesNowPlaying_API.sendRequest(withCompletion: transformResponseToModel)
    }
    
    func getMovieDetails(forMovie movieID: Int, andOnCompletion completionBlock: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        
        func transformResponseToModel(_ result: Any?, _ error: Error?) -> Void {
        }
        
        MovieDB_MovieDetailsByID_API.sendRequest(forMovie: movieID, andOnCompletion: transformResponseToModel)
    }
    
    
    func getMoviesInCollection(withID collectionID: Int, andOnCompletion completionBlock: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        
        func transformResponseToModel(_ result: Any?, _ error: Error?) -> Void {
        }
        
        MovieDB_MoviesCollection_API.sendRequest(withID: collectionID, andOnCompletion: transformResponseToModel)
    }
}
