//
//  ChatInfo.swift
//  VIO
//
//  Summary: ChatInfo Component
//  Description: An object model class to consume chat data.
//
//  Created by Arun Kumar on 03/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation

class ChatInfo {
    public var participantName : String
    public var message : String
    public var isLoginUser : Bool
    public var participantIndex : Int?
    
    init(participantName: String, chatMessage: String, participantType: Bool) {
        self.participantName = participantName
        self.message = chatMessage
        self.isLoginUser = participantType
    }
}
