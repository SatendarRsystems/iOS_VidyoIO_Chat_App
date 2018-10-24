//
//  ChatVC.swift
//  VIO
//
//  Summary: ChatVC Component
//  Description: Used to display text chat creen.
//
//  Created by Arun Kumar on 01/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, VCConnectorIRegisterMessageEventListener, UITextViewDelegate {
    
    @IBOutlet weak var tblViewObj: UITableView!
    @IBOutlet weak var txtViewSend: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VidyoManager.connector?.registerMessageEventListener(self)
        
        if VidyoManager.arrChatMessages.count > 0 {
            self.tblViewObj.scrollToRow(at: IndexPath(row: VidyoManager.arrChatMessages.count - 1, section: 0), at: .bottom, animated: true)
        }
    }
    
    /**
     A method to initialize basic view of this screen.
     */
    func initView() {
        // Do any additional setup after loading the view.        
        tblViewObj.rowHeight = UITableViewAutomaticDimension
        tblViewObj.estimatedRowHeight = 140
        initTextViewSend()
    }
    
    /**
     A method to initialize send textview of this screen.
     */
    func initTextViewSend() {
        txtViewSend.text = Constants.textView.placeholderText
        txtViewSend.textColor = UIColor.lightGray
        txtViewSend.selectedTextRange = txtViewSend.textRange(from: txtViewSend.beginningOfDocument, to: txtViewSend.beginningOfDocument)
    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnGroup(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickedBtnVideo(_ sender: Any) {
        self.navigationController?.pushViewController(VidyoManager.videoVC, animated: true)
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
            initTextViewSend()
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
            
            if let index = chatInfo.participantIndex {
                memberCell.lblMemberIntialLetter.backgroundColor = Constants.participantColors[index]
                memberCell.lblMemberName.textColor = Constants.participantColors[index]
            } else {
                memberCell.lblMemberIntialLetter.backgroundColor = UIColor.lightGray
                memberCell.lblMemberName.textColor = UIColor.lightGray
            }
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
                chatInfo.participantIndex = VidyoManager.arrParticipants.index(of: participant)
                VidyoManager.arrChatMessages.append(chatInfo)
                self.tblViewObj.reloadData()
                self.tblViewObj.scrollToRow(at: IndexPath(row: VidyoManager.arrChatMessages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = Constants.textView.placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, set
            // the text color to black then set its text to the
            // replacement string
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
            // For every other case, the text should change with the usual
            // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
