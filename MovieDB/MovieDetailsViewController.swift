//
//  MovieDetailsViewController.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 27/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


protocol MovieDetailsDelegate: class {
    
    func getMovieInfo()
    func getMovieDetails()
}

protocol MovieDetailsDisplay: class {
    
    func displayMovieInfo(title: String, posterImage: UIImage)
    func displayMovieDetails()
    func displayCollectionMovies(from tableDelegate: UICollectionViewDelegate, with tableDataSource: UICollectionViewDataSource)
}


class MovieDetailsViewController: UIViewController {
    
    // MARK: Public Properties
    
    var delegate: MovieDetailsDelegate?
    
    // MARK: IBActions
    
    // ??

    // MARK: IB Outlets
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!

    @IBOutlet weak var movieDetails: UITextView!
    @IBOutlet weak var collectionMovies: UICollectionView!
    
    // MARK: ViewController Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.delegate?.getMovieInfo()
    }
    
    // MARK: Private Properties
    
    var collectionViewDelegate: UICollectionViewDelegate?
    var collectionDataSource: UICollectionViewDataSource?
}


extension MovieDetailsViewController: MovieDetailsDisplay {
    
    func displayMovieInfo(title: String, posterImage: UIImage) {
        DispatchQueue.main.async {
            self.movieTitle.text = title
            self.moviePoster.image = posterImage
        }
    }
    
    func displayMovieDetails() {
        
    }

    func displayCollectionMovies(from tableDelegate: UICollectionViewDelegate, with tableDataSource: UICollectionViewDataSource) {

        self.collectionMovies.isHidden = false
        self.collectionViewDelegate = tableDelegate
        self.collectionDataSource = tableDataSource
        
        self.collectionMovies.delegate = self.collectionViewDelegate
        self.collectionMovies.dataSource = self.collectionDataSource
        
        self.collectionMovies.reloadData()
    }
    
}