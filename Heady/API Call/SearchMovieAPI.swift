//
//  SearchMovieAPI.swift
//  Heady
//
//  Created by Mayur on 22/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class SearchMovieAPI: NSObject {

    func makeAPICall(fromViewController : ViewController, page : String, query : String){
        UiUtillity.shared.showIndicatorLoader()
        
        let url                         = "\(constant.BASE_URL)/search/movie"
        let params : [String:String] = ["api_key" : constant.API_KEY,
                                        "page"    : page,
                                        "language": "en-US",
                                        "include_adult" : "false",
                                        "query"   : query]
        print("==============================================")
        print("API Call URL \(url) & Parameters are \(params)")
        
        // Making an API Call
        Utillity.shared.sendRequest(url: url, parameters: params, fromViewController: fromViewController) { (result, error) in
            
            if let responseDic  = result{
                UiUtillity.shared.hideIndicatorLoader()
                let genereArray = responseDic["results"]
                fromViewController.searchMovieAPIResponse(dic: genereArray as Any)
            }
        }
    }
}
