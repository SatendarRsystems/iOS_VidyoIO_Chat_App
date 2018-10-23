//
//  AccessTokenBase.swift
//  VIO
//
//  Summary: AccessTokenBase Component
//  Description: An object model class to consume data from GetAccessToken API
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation
 
public class AccessTokenBase {
	public var accessToken : String?
	public var username : String?
	public var status : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [AccessTokenBase]
    {
        var models:[AccessTokenBase] = []
        for item in array
        {
            models.append(AccessTokenBase(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		accessToken = dictionary["accessToken"] as? String
		username = dictionary["username"] as? String
		status = dictionary["status"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.accessToken, forKey: "accessToken")
		dictionary.setValue(self.username, forKey: "username")
		dictionary.setValue(self.status, forKey: "status")

		return dictionary
	}

}
