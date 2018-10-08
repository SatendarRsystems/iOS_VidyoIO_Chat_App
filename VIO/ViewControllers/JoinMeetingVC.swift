//
//  JoinMeetingVC.swift
//  VIO
//
//  Created by Arun Kumar on 25/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

class JoinMeetingVC: UIViewController, VCConnectorIConnect {
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMeetingID: UITextField!
    @IBOutlet weak var constLogoTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textFieldUserName.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.textFieldMeetingID.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.videoView.isHidden = true
        VCConnectorPkg.vcInitialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.constLogoTop.constant = self.view.frame.height * 0.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Actions
    
    @IBAction func clickedBtnJoinMeeting(_ sender: Any) {
        
//        os_log("-----------%d", log: OSLog.default, type: .debug, (self.textFieldUserName.text?.isEmpty)!)
        
        if (self.textFieldUserName.text?.isEmpty)! {
            alert(message: "Please enter username.")
        } else if (self.textFieldMeetingID.text?.isEmpty)! {
            alert(message: "Please enter meeting ID.")
        } else {
            Utile.saveUserName(self.textFieldUserName.text?.trimmingCharacters(in: .whitespaces))
            Utile.saveMeetingID(self.textFieldMeetingID.text?.trimmingCharacters(in: .whitespaces))
            self.requesGetAccessTokenData()
        }
    }
    
    //MARK: - API calls
    
    /**
     A method to get schedule data from server.
     */
    private func requesGetAccessTokenData() {
        
        AFWrapper.requestGetAccessToken(params: nil, success: {
            (resJson) -> Void in
            
            let accessTokenBase = AccessTokenBase.init(dictionary: resJson.dictionaryObject! as NSDictionary)
            Utile.saveAccessToken(accessTokenBase?.accessToken)
            Utile.showProgressIndicator()
            VidyoManager.sharedInstance.initVidyoConnector(videoView: self.videoView)
            VidyoManager.sharedInstance.refreshUI()
            VidyoManager.sharedInstance.connectMeeting(self)
            VidyoManager.sharedInstance.switchOffMic(switchValue: true)
            VidyoManager.sharedInstance.switchOffSpeaker(switchValue: true)
            VidyoManager.sharedInstance.switchOffCamera(switchValue: true)

        }) {
            (error) -> Void in
            
            self.alert(message: error.localizedDescription)
        }
    }
    
    // MARK: - VCConnectorIConnect delegate
    
    func onSuccess() {
        print("Connection Successful")
        
        DispatchQueue.main.async {
            Utile.hideProgressIndicator()            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.loginToHomeVC()
            
        }
    }
    
    func onFailure(_ reason: VCConnectorFailReason) {
        print("Connection failed \(reason)")
        
        DispatchQueue.main.async {
            Utile.hideProgressIndicator()
        }
    }
    
    func onDisconnected(_ reason: VCConnectorDisconnectReason) {
        print("Call Disconnected")
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if (appDelegate.window?.rootViewController?.isKind(of: UINavigationController.self))! {
                appDelegate.logoutToHomeVC()
            }            
        }
    }
}
