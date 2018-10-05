//
//  VidyoManager.swift
//  VIO
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class VidyoManager: NSObject {
    static let sharedInstance = VidyoManager()
    static var connector:VCConnector?
    static var vidyoView:UIView?
    static var arrChatMessages: [ChatInfo] = []
    
    
    // MARK: - VidyoWrapper
    
    func initVidyoConnector(videoView: UIView) {
        VidyoManager.vidyoView = videoView
        VidyoManager.connector = VCConnector(UnsafeMutableRawPointer(&VidyoManager.vidyoView),
                                viewStyle: .default,
                                remoteParticipants: 4,
                                logFileFilter: UnsafePointer("info@VidyoClient info@VidyoConnector warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    }
    
    @objc func refreshUI() {
        DispatchQueue.main.async {
            VidyoManager.connector?.showView(at: UnsafeMutableRawPointer(&VidyoManager.vidyoView),
                                     x: 0,
                                     y: 0,
                                     width: UInt32(VidyoManager.vidyoView!.frame.size.width),
                                     height: UInt32((VidyoManager.vidyoView?.frame.size.height)!))
        }
    }
    
    func connectMeeting(_ vc: VCConnectorIConnect) {
        VidyoManager.connector?.connect("prod.vidyo.io",
                           token: Utile.getAccessToken(),
                           displayName: Utile.getUserName(),
                           resourceId: Utile.getMeetingID(),
                           connectorIConnect: vc)
    }
    
    func disconnectMeeting() {
        VidyoManager.connector?.disconnect()
        VidyoManager.connector = nil
    }
    
    func disableMeeting() {
        VidyoManager.connector?.disable()
        VidyoManager.connector = nil
    }
    
    func sendMessage(_ textMsg: String) {
        if (!textMsg.isEmpty ) {
            VidyoManager.connector?.sendChatMessage(textMsg)
        }
    }
    
    func switchOffMic(switchValue: Bool) {
        VidyoManager.connector?.setMicrophonePrivacy(switchValue)

    }
    
    func switchOffSpeaker(switchValue: Bool) {
        VidyoManager.connector?.setSpeakerPrivacy(switchValue)
    }
    
    func switchOffCamera(switchValue: Bool) {
        VidyoManager.connector?.setCameraPrivacy(switchValue)
    }
}
