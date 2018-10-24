//
//  JoinMeetingVC.swift
//  VIO
//
//  Summary: JoinMeetingVC Component
//  Description: Used to display join meeting screen where user submit his username and meeting ID.
//
//  Created by Arun Kumar on 25/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

class JoinMeetingVC: UIViewController, VCConnectorIConnect {
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMeetingID: UITextField!
    @IBOutlet weak var constLogoTop: NSLayoutConstraint!
    @IBOutlet weak var btnJoinMeeting: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
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
    
    /**
     A method to initialize basic view of this screen.
     */
    func initView() {
        self.textFieldUserName.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.textFieldMeetingID.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        VCConnectorPkg.vcInitialize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        VidyoManager.videoVC = storyboard.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC
    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnJoinMeeting(_ sender: Any) {        
        let arrUserName = self.textFieldUserName.text?.components(separatedBy: " ")
        
        if ((arrUserName?.count)! > 1) {
            alert(message: "No space allowed in username.")
        } else {
            Utile.saveUserName(self.textFieldUserName.text?.trimmingCharacters(in: .whitespaces))
            Utile.saveMeetingID(self.textFieldMeetingID.text?.trimmingCharacters(in: .whitespaces))
            self.requesGetAccessTokenData()
        }
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if (!(textFieldUserName.text?.isEmpty)! && !(textFieldMeetingID.text?.isEmpty)!) {
            btnJoinMeeting.isEnabled = true
        } else {
            btnJoinMeeting.isEnabled = false
        }
    }
    
    //MARK: - API calls
    
    /**
     A method to get access token from server.
     */    
    private func requesGetAccessTokenData() {
        
        AFWrapper.requestGetAccessToken(params: nil, success: {
            (resJson) -> Void in
            
            let accessTokenBase = AccessTokenBase.init(dictionary: resJson.dictionaryObject! as NSDictionary)
            Utile.saveAccessToken(accessTokenBase?.accessToken)
            Utile.showProgressIndicator()
            VidyoManager.sharedInstance.initVidyoConnector()
            VidyoManager.sharedInstance.refreshUI()
            VidyoManager.sharedInstance.connectMeeting(self)
            VidyoManager.sharedInstance.switchOffMic(true)
            VidyoManager.sharedInstance.switchOffSpeaker(true)
            VidyoManager.sharedInstance.switchOffCamera(true)

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
            
            if reason.rawValue == 5 {
                self.alert(message: "VCConnectorFailReasonInvalidToken")
            }
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
