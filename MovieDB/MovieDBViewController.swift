//
//  ViewController.swift
//  MovieDB
//
//  Created by Aldo Bergamini on 25/09/2018.
//  Copyright © 2018 iBat Inc. All rights reserved.
//

import UIKit


protocol NowPlayingMoviesDelegate: class {
    
    func getMoviesPlayingNow()
}

protocol NowPlayingMoviesDisplay: class {
    
    func displayMovies(from tableDelegate: UICollectionViewDelegate, with tableDataSource: UICollectionViewDataSource)
}


class MovieDBViewController: UIViewController {
    
    // MARK: Public Properties
    
    var delegate: NowPlayingMoviesDelegate?
    
    // MARK: IBActions
    
    // ??
    
    
    // MARK: IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarHeight: NSLayoutConstraint! // defaultHeight -> 56 pixel
    @IBOutlet weak var moviesCollectionView: UICollectionView!

    
    // MARK: Private Properties
    
    var collectionViewDelegate: UICollectionViewDelegate?
    var collectionDataSource: UICollectionViewDataSource?
}


extension MovieDBViewController: NowPlayingMoviesDisplay {

    func displayMovies(from tableDelegate: UICollectionViewDelegate, with tableDataSource: UICollectionViewDataSource) {

        self.collectionViewDelegate = tableDelegate
        self.collectionDataSource = tableDataSource
        
        self.moviesCollectionView.delegate = self.collectionViewDelegate
        self.moviesCollectionView.dataSource = self.collectionDataSource

        self.moviesCollectionView.reloadData()
    }
}
