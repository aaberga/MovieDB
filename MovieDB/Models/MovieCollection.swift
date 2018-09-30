//
//  MovieCollection.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import Foundation



struct MovieCollection {
    
    let id: Int
    
    let name: String
    let overview: String
    
    let posterPath: String
    let parts: [Movie]
}
