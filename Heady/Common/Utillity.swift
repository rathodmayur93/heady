//
//  Utillity.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit

class Utillity {
    
    //MARK:- Variables
    static let shared   : Utillity     = Utillity()
    
    func sendRequest(url: String, parameters: [String : String], fromViewController : UIViewController, completionHandler: @escaping (NSDictionary?, NSError?) -> Void) {
        
        if(UiUtillity.shared.isConnectedToNetwork()){
            let parameterString = parameters.stringFromHttpParameters()
            let requestURL      = URL(string:"\(url)?\(parameterString)")!       // api url
            print("API Call URL \(requestURL)")
            
            var request         = URLRequest(url: requestURL)
            request.httpMethod  = "GET"
           
            let task1 = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // api calling errors
                if error != nil{
                    self.handlingErrors(errorString: error.debugDescription,fromViewController: fromViewController)
                    print("Certificate Error -> \(error!)")
                    return
               
                }else{
                    // api json response
                    if let urlContent = data{
                        do {
                            let result = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            DispatchQueue.main.sync(execute: {
                                completionHandler(result, nil)
                            })
                        }
                        catch{
                            UiUtillity.shared.hideIndicatorLoader()
                            UiUtillity.shared.showAlert(title: "Error", message: "We are facing some error. Please Try Again Later", logMessage: "Failed To Convert Dic", fromController: fromViewController)
                        }
                    }
                }
            }
            task1.resume()
            
        }else{
            // Show No Internet Dialog
            noInternetError(fromViewController: fromViewController)
        }
    }

    // MARK:- Handle API Call Network Errors
    func handlingErrors(errorString : String, fromViewController : UIViewController){
        UiUtillity.shared.hideIndicatorLoader()
        if(errorString.contains("timed out")){
            UiUtillity.shared.showAlert(title: "Error", message: "Request Timed Out", logMessage: "Request Timed Out", fromController: fromViewController)
        }else if(errorString.contains("connection was lost")){
            UiUtillity.shared.showAlert(title: "Error", message: "The network connection was lost.", logMessage: "The network connection was lost.", fromController: fromViewController)
        }else if(errorString.contains("appears to be offline")){
            UiUtillity.shared.showAlert(title: "Error", message: "The Internet connection appears to be offline.", logMessage: "The Internet connection appears to be offline.", fromController: fromViewController)
        }else if(errorString.contains("not connect to")){
            UiUtillity.shared.showAlert(title: "Error", message: "Could not connect to the server", logMessage: "Could not connect to the server", fromController: fromViewController)
        }
    }
    
    // MARK:- No internet Dialog
    func noInternetError(fromViewController : UIViewController){
        UiUtillity.shared.hideIndicatorLoader()
        UiUtillity.shared.showAlert(title: "No Internet", message: "oops..! Look like there is no internet connection", logMessage: "No Internet Error", fromController: fromViewController)
    }
    
}
