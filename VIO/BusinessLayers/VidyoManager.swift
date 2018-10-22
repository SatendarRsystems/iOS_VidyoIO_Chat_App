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
    let videoView: UIView!
    static var videoVC:VideoVC!    
    static var arrChatMessages: [ChatInfo] = []
    static var arrParticipants: [VCParticipant] = []
    
    override init() {
        self.videoView = VidyoManager.videoVC.view.viewWithTag(101)
    }
    
    // MARK: - VidyoWrapper
    
    /**
     Used to create an instance of Vidyo connector
     */
    func initVidyoConnector() {
        var videoViewMutable = self.videoView
        VidyoManager.connector = VCConnector(UnsafeMutableRawPointer(&videoViewMutable),
                                viewStyle: .default,
                                remoteParticipants: 4,
                                logFileFilter: UnsafePointer("info@VidyoClient info@VidyoConnector warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    }
    
    /**
     Used to refresh video chat screen
     */
    @objc func refreshUI() {
        var videoViewMutable = self.videoView!
        DispatchQueue.main.async {
            VidyoManager.connector?.showView(at: UnsafeMutableRawPointer(&videoViewMutable),
                                     x: 0,
                                     y: 0,
                                     width: UInt32(videoViewMutable.frame.size.width),
                                     height: UInt32(videoViewMutable.frame.size.height))
        }
    }
    
    /**
     Used to connect video chat meeting
     */
    func connectMeeting(_ vc: VCConnectorIConnect) {
        VidyoManager.connector?.connect("prod.vidyo.io",
                           token: Utile.getAccessToken(),
                           displayName: Utile.getUserName(),
                           resourceId: Utile.getMeetingID(),
                           connectorIConnect: vc)
    }
    
    /**
     Used to disconnect video chat meeting
     */
    func disconnectMeeting() {
        VidyoManager.connector?.disconnect()
        VidyoManager.connector = nil
    }
    
    /**
     Used to disable video chat meeting
     */
    func disableMeeting() {
        VidyoManager.connector?.disable()
        VidyoManager.connector = nil
    }
    
    /**
     Used to send chat message during meeting
     */
    func sendMessage(_ textMsg: String) {
        if (!textMsg.isEmpty ) {
            VidyoManager.connector?.sendChatMessage(textMsg)
        }
    }
    
    /**
     Used to switch on/off mic
     */
    func switchOffMic(_ switchValue: Bool) {
        VidyoManager.connector?.setMicrophonePrivacy(switchValue)

    }
    
    /**
     Used to switch on/off speaker
     */
    func switchOffSpeaker(_ switchValue: Bool) {
        VidyoManager.connector?.setSpeakerPrivacy(switchValue)
    }
    
    /**
     Used to switch on/off camera
     */
    func switchOffCamera(_ switchValue: Bool) {
        VidyoManager.connector?.setCameraPrivacy(switchValue)
    }
    
    /**
     Used to switch front/back camera
     */
    func switchCamera() {
         VidyoManager.connector?.cycleCamera()
    }
}
