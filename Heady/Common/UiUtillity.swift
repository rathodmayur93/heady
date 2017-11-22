//
//  UiUtillity.swift
//  Heady
//
//  Created by Mayur on 21/11/17.
//  Copyright © 2017 mayur. All rights reserved.
//

import UIKit
import SystemConfiguration

class UiUtillity: NSObject {

    // MARK:- Variables
    static let shared               : UiUtillity                 = UiUtillity()
    let spinningActivityIndicator   : UIActivityIndicatorView    = UIActivityIndicatorView()
    let container                   : UIView                     = UIView()
    
    // MARK:- Show Alert Function
    func showAlert(title: String, message: String, logMessage: String, fromController controller: UIViewController){
        
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: title, message:
                message, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default,handler: nil))
            
            controller.present(alertController, animated: true, completion: nil)
            print(logMessage)
        }
    }

    // MARK:- Check Internet Functino
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    // MARK:- Show Loader
    func showIndicatorLoader(){
        
        if(isConnectedToNetwork()){
            let window                      = UIApplication.shared.keyWindow
            container.frame                 = UIScreen.main.bounds
            container.backgroundColor       = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.4)
            
            let loadingView: UIView         = UIView()
            loadingView.frame               = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center              = container.center
            loadingView.backgroundColor     = UIColor.gray //uiFun.hexStringToUIColor(hex: ridlrColors.ridlrBrandColor)
            loadingView.clipsToBounds       = true
            loadingView.layer.cornerRadius  = 40
            
            spinningActivityIndicator.frame                         = CGRect(x: 0, y: 0, width: 40, height: 40)
            spinningActivityIndicator.hidesWhenStopped              = true
            spinningActivityIndicator.activityIndicatorViewStyle    = UIActivityIndicatorViewStyle.whiteLarge
            spinningActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
            loadingView.addSubview(spinningActivityIndicator)
            container.addSubview(loadingView)
            window?.addSubview(container)
            spinningActivityIndicator.startAnimating()
        }
    }
    
    // MARK:- Hide Loader
    func hideIndicatorLoader(){
        spinningActivityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
}
