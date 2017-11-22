//
//  MovieDetailViewController.swift
//  Heady
//
//  Created by Mayur on 23/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet var moviePoster       : UIImageView!
    @IBOutlet var movieTitle        : UILabel!
    @IBOutlet var releaseDate       : UILabel!
    @IBOutlet var movieSynopsis     : UILabel!
    @IBOutlet var movieRating       : UILabel!
    @IBOutlet var moviePopularity   : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Setting UI
    func setUI(){
        moviePoster.loadFromURL(photoUrl: "\(constant.IMAGE_BASE_URL)\(genereMovieList[selectedItemIndex].posterImage)")
        movieTitle.text     = genereMovieList[selectedItemIndex].title
        releaseDate.text    = genereMovieList[selectedItemIndex].releaseDate
        movieSynopsis.text  = genereMovieList[selectedItemIndex].overview
        movieRating.text    = "\(genereMovieList[selectedItemIndex].voteAvg)"
        moviePopularity.text = "\(genereMovieList[selectedItemIndex].popularity)"
    }

}
