//
//  Utile.swift
//  VIO
//
//  Summary: Utile Component
//  Description: Used to define all common static methods.
//
//  Created by Arun Kumar on 26/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation
import UIKit

class Utile {
    
    //MARK: - Progress indicators
    
    /**
     A method to display activity indicator during API call.
     */
    static func showProgressIndicator() {
        
        if let window = UIApplication.shared.delegate?.window {
            
            if (window?.viewWithTag(201)) != nil {
                return
            }
            
            let bgView = UIView()
            window?.addSubview(bgView)
            bgView.tag = 201
            bgView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 0.3961098031)
            bgView.isUserInteractionEnabled = false
            bgView.translatesAutoresizingMaskIntoConstraints = false
            bgView.topAnchor.constraint(equalTo: (window?.topAnchor)!).isActive = true
            bgView.bottomAnchor.constraint(equalTo: (window?.bottomAnchor)!).isActive = true
            bgView.leadingAnchor.constraint(equalTo: (window?.leadingAnchor)!).isActive = true
            bgView.trailingAnchor.constraint(equalTo: (window?.trailingAnchor)!).isActive = true
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.tag = 102
            bgView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: (window?.centerXAnchor)!).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: (window?.centerYAnchor)!).isActive = true
            
            window?.isUserInteractionEnabled = false
        }
    }
    
    /**
     A method to hide activity indicator which display during API call.
     */
    static func hideProgressIndicator() {
        
        if let window = UIApplication.shared.delegate?.window {
            let bgView = window?.viewWithTag(201)
            bgView?.removeFromSuperview()
            window?.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - App user data
    
    /**
     A method to save user name in local persistance storage
     */
    static func saveUserName(_ userName: String?) {
        
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    /**
     A method to get user name from local persistance storage
     */
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: "userName")
    }
    
    /**
     A method to save meeting ID in local persistance storage
     */
    static func saveMeetingID(_ meetingID: String?) {
        
        UserDefaults.standard.set(meetingID, forKey: "meetingID")
    }
    
    /**
     A method to get meeting ID from local persistance storage
     */
    static func getMeetingID() -> String? {
        return UserDefaults.standard.string(forKey: "meetingID")
    }
    
    /**
     A method to save user accessb token in local persistance storage
     */
    static func saveAccessToken(_ token: String?) {
        
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    /**
     A method to get user access token from local persistance storage
     */
    static func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
}
