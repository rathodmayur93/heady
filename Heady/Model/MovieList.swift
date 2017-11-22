//
//  MovieList.swift
//  Heady
//
//  Created by Mayur on 22/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieList: NSObject {

    var title           : String    = ""
    var overview        : String    = ""
    var releaseDate     : String    = ""
    var voteAvg         : CGFloat   = 0.0
    var popularity      : Double    = 0.0
    var posterImage     : String    = ""
    
    required init(dict: Dictionary<String, Any>) {
        
        if let movieTitle       = dict["original_title"] as? String {
            self.title          = movieTitle
        }
        
        if let movieOverView    = dict["overview"] as? String {
            self.overview       = movieOverView
        }
        
        if let movieRelease     = dict["release_date"] as? String {
            self.releaseDate    = movieRelease
        }
        
        if let moviePoster      = dict["poster_path"] as? String {
            self.posterImage    = moviePoster
        }
        
        if let movieVote        = dict["vote_average"] as? CGFloat {
            self.voteAvg        = movieVote
        }
        
        if let moviePopularity  = dict["popularity"] as? Double {
            self.popularity     = moviePopularity
        }
        
    }
}
