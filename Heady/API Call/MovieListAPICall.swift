//
//  MovieListAPICall.swift
//  Heady
//
//  Created by Mayur on 22/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieListAPICall {

    func makeAPICall(fromViewController : ViewController, page : String, genereId : String){
        UiUtillity.shared.showIndicatorLoader()
        
        let url                         = "\(constant.BASE_URL)/genre/\(genereId)/movies"
        let params : [String:String] = ["api_key" : constant.API_KEY,
                                        "page"    : page,
                                        "language": "en-US",
                                        "include_adult" : "false",
                                        "sort_by" : "created_at.asc"]
        print("==============================================")
        print("API Call URL \(url) & Parameters are \(params)")
        
        // Making an API Call
        Utillity.shared.sendRequest(url: url, parameters: params, fromViewController: fromViewController) { (result, error) in
            
            if let responseDic  = result{
                UiUtillity.shared.hideIndicatorLoader()
                let genereArray = responseDic["results"]
                fromViewController.moviesAPIResponse(dic: genereArray as Any)
            }
        }
    }
}
