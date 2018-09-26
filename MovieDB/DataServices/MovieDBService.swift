//
//  MovieDBService.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation


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
