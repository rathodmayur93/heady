//
//  SearchMovieParser.swift
//  Heady
//
//  Created by Mayur on 22/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class SearchMovieParser: NSObject {

    func parse(data: Any, error: NSErrorPointer) -> MovieList? {
        var movieList: MovieList?
        
        if let placeData = data as? Dictionary<String, Any> {
            movieList    = MovieList(dict: placeData)
        } else {
            error?.pointee = NSError(domain: "Could not parse the given data", code: 0, userInfo: nil)
        }
        
        return movieList
    }
    
    func parseList(data: Any, error: NSErrorPointer) -> Array<MovieList> {
        var movieListArray = Array<MovieList>()
        
        guard let foundDataArray = data as? Array<Dictionary<String, Any>> else {
            error?.pointee = NSError(domain: "Could not parse the given data", code: 0, userInfo: nil)
            return movieListArray
        }
        
        for dict in foundDataArray {
            if let place = self.parse(data: dict, error: error) {
                movieListArray.append(place)
            }
        }
        
        return movieListArray
    }
}
