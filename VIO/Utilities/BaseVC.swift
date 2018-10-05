//
//  BaseVC.swift
//  VIO
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
     var connector:VCConnector?
     @IBOutlet weak var vidyoView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - VidyoWrapper
    
    func initVidyoConnector() {
        self.vidyoView.isHidden = true
        connector = VCConnector(UnsafeMutableRawPointer(&self.vidyoView),
                                viewStyle: .default,
                                remoteParticipants: 4,
                                logFileFilter: UnsafePointer("info@VidyoClient info@VidyoConnector warning"),
                                logFileName: UnsafePointer(""),
                                userData: 0)
    }
    
    @objc func refreshUI() {
        DispatchQueue.main.async {
            self.connector?.showView(at: UnsafeMutableRawPointer(&self.vidyoView),
                                     x: 0,
                                     y: 0,
                                     width: UInt32(self.vidyoView.frame.size.width),
                                     height: UInt32(self.vidyoView.frame.size.height))
        }
    }
    
    func connectMeeting(_ vc: VCConnectorIConnect) {
        connector?.connect("prod.vidyo.io",
                           token: Utile.getAccessToken(),
                           displayName: Utile.getUserName(),
                           resourceId: Utile.getMeetingID(),
                           connectorIConnect: vc)
    }
    
    func disconnectMeeting() {
        connector?.disconnect()
        //        connector?.disable()
        //        connector = nil
    }
    
    func sendMessage(_ textMsg: String) {
        if (!textMsg.isEmpty ) {
            connector?.sendChatMessage(textMsg)
        }
    }

}
