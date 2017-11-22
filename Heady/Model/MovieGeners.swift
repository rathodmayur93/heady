//
//  MovieGeners.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieGeners: NSObject {

    var id         : Int       = 0
    var name       : String    = ""
    
    required init?(dict: Dictionary<String, Any>) {
       
        if let genereId   = dict["id"] as? Int {
            self.id       = genereId
        }
        
        if let name     = dict["name"] as? String {
            self.name   = name
        }
    }
}
