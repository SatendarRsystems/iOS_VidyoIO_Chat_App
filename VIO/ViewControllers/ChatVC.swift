//
//  ChatVC.swift
//  VIO
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, VCConnectorIRegisterMessageEventListener {
    
    @IBOutlet weak var tblViewObj: UITableView!
    @IBOutlet weak var txtViewSend: UITextView!
//    var parentVC:ParticipantsVC? = nil
//    var arrMessages: [ChatInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        parentVC?.connector?.registerMessageEventListener(self)
//        os_log("connector-------%@", log: .default, type: .default, (parentVC?.connector)!)
//        parentVC?.connector?.registerMessageEventListener(self)
        
        tblViewObj.rowHeight = UITableViewAutomaticDimension
        tblViewObj.estimatedRowHeight = 140

        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VidyoManager.connector?.registerMessageEventListener(self)
        
        if VidyoManager.arrChatMessages.count > 0 {
            self.tblViewObj.scrollToRow(at: IndexPath(row: VidyoManager.arrChatMessages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnGroup(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedBtnVideo(_ sender: Any) {
    }
    
    @IBAction func clickedBtnExit(_ sender: Any) {
        VidyoManager.sharedInstance.disableMeeting()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logoutToHomeVC()
    }
    
    @IBAction func clickedBtnSend(_ sender: Any) {
        
        if (!self.txtViewSend.text.isEmpty ) {
            VidyoManager.sharedInstance.sendMessage(self.txtViewSend.text)
            let chatInfo = ChatInfo(participantName: Utile.getUserName()!, chatMessage: self.txtViewSend.text, participantType: true)
            VidyoManager.arrChatMessages.append(chatInfo)
            self.txtViewSend.text = nil
            
            self.tblViewObj.reloadData()
            self.tblViewObj.scrollToRow(at: IndexPath(row: VidyoManager.arrChatMessages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VidyoManager.arrChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatInfo = VidyoManager.arrChatMessages[indexPath.row]
        
        var cell: UITableViewCell        
        
        if chatInfo.isLoginUser == false {
            let memberCell = tableView.dequeueReusableCell(withIdentifier: "ChatboxMemberCell", for: indexPath) as! ChatboxMemberCell
            let indexStartOfText = chatInfo.participantName.index(chatInfo.participantName.startIndex, offsetBy: 0)
            memberCell.lblMemberIntialLetter.text = String(chatInfo.participantName[...indexStartOfText]).uppercased()
            memberCell.lblMemberName.text = chatInfo.participantName
            memberCell.lblMemberMsg.text = chatInfo.message
            cell = memberCell
            
        } else {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "ChatboxUserCell", for: indexPath) as! ChatboxUserCell
            userCell.lblUserMsg.text = chatInfo.message
            cell = userCell
        }
        
        // Configure the cell...

        
        return cell
    }
    
    // MARK: - VCConnectorIRegisterMessageEventListener
    
    func onChatMessageReceived(_ participant: VCParticipant!, chatMessage: VCChatMessage!) {
        
        DispatchQueue.main.async {
            
            let msg = String(chatMessage.body)
            
            if (!msg.isEmpty) {
                let chatInfo = ChatInfo(participantName: participant.getName(), chatMessage: msg, participantType: false)
                VidyoManager.arrChatMessages.append(chatInfo)
                self.tblViewObj.reloadData()
                self.tblViewObj.scrollToRow(at: IndexPath(row: VidyoManager.arrChatMessages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}
