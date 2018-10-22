//
//  AFWrapper.swift
//  VIO
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper {
    static let baseUrl = "https://us-central1-vidyo-1.cloudfunctions.net"
//    static let baseUrl = "http://vod-demoserver.india.rsystems.com:7000"
    
    /**
     A method to get authontication headers in key-value format
     */
    class func getoAuthHeaders() -> HTTPHeaders {
        
        let oauthHeaders: HTTPHeaders = [
//            "authorization": UserDefaults.standard.string(forKey: "oauthToken")!,
            "accept": "application/json"
        ]
        return oauthHeaders
    }
    
    //MARK: - Base request  URL Method
    
    /**
     A method to  request the API through GET or POST method
     */
    class func requestURL(_ strURL: String ,params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let oauthHeaders = self.getoAuthHeaders()
        
        Utile.showProgressIndicator()
        
        print("strURL: \(strURL)")
        
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: oauthHeaders).validate().responseJSON { (responseObject) -> Void in
            
            Utile.hideProgressIndicator()
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                 print("resJson: \(resJson)")
                success(resJson)
            }
            else if responseObject.result.isFailure {
//                let error : Error = MyError.customError
                print("error: \(responseObject.result.error?.localizedDescription)")
                failure(responseObject.result.error!)
            }
        }
    }
    
    //MARK: - JoinMeetingVC screen API methods
    
    /**
     A method to  request the access token through GET method
     */
    class func requestGetAccessToken(params : [String : AnyObject]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let requestUrl = String.init(format: "/authToken?username=%@", Utile.getUserName()!)
//        let requestUrl = String.init(format: "/getAccessToken?username=%@", Utile.getUserName()!)

        let resultStr = baseUrl + requestUrl
        
        AFWrapper.requestURL(resultStr,params: params, success: {
            (resJson) -> Void in
            
            success(resJson)
        }) {
            (error) -> Void in
            failure(error)
        }
    }
}
