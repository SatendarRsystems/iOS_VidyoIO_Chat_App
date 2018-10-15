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
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldMeetingID: UITextField!
    @IBOutlet weak var constLogoTop: NSLayoutConstraint!
    @IBOutlet weak var btnJoinMeeting: UIButton!
    
//    var videoVC: UIViewController!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initView() {
        self.textFieldUserName.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        self.textFieldMeetingID.layer.borderColor = #colorLiteral(red: 0.3960784314, green: 0.3960784314, blue: 0.3960784314, alpha: 1)
        VCConnectorPkg.vcInitialize()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        VidyoManager.videoVC = storyboard.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC
//        os_log("videoVC-----------%@", log: OSLog.default, type: .debug, VidyoManager.videoVC)
//        os_log("viewVideo-----------%@", log: OSLog.default, type: .debug, VidyoManager.videoVC.view.viewWithTag(101)!)

    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnJoinMeeting(_ sender: Any) {
//        os_log("-----------%d", log: OSLog.default, type: .debug, (self.textFieldUserName.text?.isEmpty)!)
        
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
     A method to get schedule data from server.
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
