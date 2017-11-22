//
//  MovieGenersAPI.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class MovieGenersAPI {

    func makeAPICall(fromViewController : GeneresViewController, page : String){
        UiUtillity.shared.showIndicatorLoader()
        
        let url                         = "\(constant.BASE_URL)/genre/movie/list"
        let params : [String:String] = ["api_key" : constant.API_KEY,
                                        "language": "en-US"]
        print("==============================================")
        print("API Call URL \(url) & Parameters are \(params)")
        
        // Making an API Call
        Utillity.shared.sendRequest(url: url, parameters: params, fromViewController: fromViewController) { (result, error) in
            
            if let responseDic  = result{
                UiUtillity.shared.hideIndicatorLoader()
                let genereArray = responseDic["genres"]
                fromViewController.generesAPIResponse(dic: genereArray as Any)
            }
        }
    }
}
