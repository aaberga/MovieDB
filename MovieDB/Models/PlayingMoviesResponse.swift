//
//  PlayingMovieModel.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation


struct PlayingMoviesResponse {
    
    let movies: [Movie]
    
    let page: Int
    
    let totalPages: Int
    let totalMovies: Int
}
