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
    
    func initVidyoConnector() {
        var videoViewMutable = self.videoView
        VidyoManager.connector = VCConnector(UnsafeMutableRawPointer(&videoViewMutable),
                                viewStyle: .default,
                                remoteParticipants: 4,
                                logFileFilter: UnsafePointer("info@VidyoClient info@VidyoConnector warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    }
    
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
    
    func switchOffMic(_ switchValue: Bool) {
        VidyoManager.connector?.setMicrophonePrivacy(switchValue)

    }
    
    func switchOffSpeaker(_ switchValue: Bool) {
        VidyoManager.connector?.setSpeakerPrivacy(switchValue)
    }
    
    func switchOffCamera(_ switchValue: Bool) {
        VidyoManager.connector?.setCameraPrivacy(switchValue)
    }
}
