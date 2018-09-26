//
//  MovieDetailsModel.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation


struct MovieDetails {
    
    let id: Int

    let homePage: String
    let budget: Int
    let popularity: Float
    let voteAverage: Float
    let voteCount: Int
    let status: String

    let collection: MovieCollectionReference?
}

struct MovieCollectionReference {

    let id: Int

    let name: String
    let posterPath: String
}
