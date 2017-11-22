//
//  MovieGenereParser.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieGenereParser: NSObject {

    func parse(data: Any, error: NSErrorPointer) -> MovieGeners? {
        var movieGeneres: MovieGeners?
        
        if let placeData = data as? Dictionary<String, Any> {
            movieGeneres = MovieGeners(dict: placeData)
        } else {
            error?.pointee = NSError(domain: "Could not parse the given data", code: 0, userInfo: nil)
        }
        
        return movieGeneres
    }
    
    func parseList(data: Any, error: NSErrorPointer) -> Array<MovieGeners> {
        var placeList = Array<MovieGeners>()
        guard let foundDataArray = data as? Array<Dictionary<String, Any>> else {
            error?.pointee = NSError(domain: "Could not parse the given data", code: 0, userInfo: nil)
            return placeList
        }
        
        for dict in foundDataArray {
            if let place = self.parse(data: dict, error: error) {
                placeList.append(place)
            }
        }
        
        return placeList
    }
}
