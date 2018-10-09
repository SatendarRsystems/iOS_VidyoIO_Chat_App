//
//  ParticipantsVC.swift
//  VIO
//
//  Created by Arun Kumar on 26/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit
import os.log

class ParticipantsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, VCConnectorIRegisterParticipantEventListener, VCConnectorIRegisterMessageEventListener {
    
    @IBOutlet weak var lblMeetingID: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTotalMember: UILabel!
    @IBOutlet weak var tblViewObj: UITableView!
    
//    var arrParticipant: [VCParticipant] = []
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

/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if let chatVC = segue.destination as? ChatVC {
//            chatVC.parentVC = self
//        }
    }
*/
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        VidyoManager.connector?.registerParticipantEventListener(self)
        VidyoManager.connector?.registerMessageEventListener(self)
    }
    
    func initView() {
        self.lblMeetingID.text = Utile.getMeetingID()
        self.lblUserName.text = Utile.getUserName()
        
        //        self.initVidyoConnector()
        //        VidyoManager.connector?.registerParticipantEventListener(self)
        //         VidyoManager.connector?.registerMessageEventListener(self)
        //        self.refreshUI()
        //        self.connectMeeting(self)
    }
    
    // MARK: - Actions
    
    @IBAction func clickedBtnChat(_ sender: Any) {
    }
    
    @IBAction func clickedBtnVideo(_ sender: Any) {
        self.navigationController?.pushViewController(VidyoManager.videoVC, animated: true)
    }
    
    @IBAction func clickedBtnExit(_ sender: Any) {
        VidyoManager.sharedInstance.disableMeeting()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logoutToHomeVC()
    } 
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VidyoManager.arrParticipants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "participantsCell", for: indexPath) as! ParticipantsCell
        
        // Configure the cell...
        if let participantNmae = VidyoManager.arrParticipants[indexPath.row].getName() {
            cell.lblParticipantName.text = participantNmae
            let indexStartOfText = participantNmae.index(participantNmae.startIndex, offsetBy: 0)
            cell.lblInitialLetter.text = String(participantNmae[...indexStartOfText]).uppercased()
            cell.lblInitialLetter.backgroundColor = Constants.participantColors[indexPath.row]
        }
        
        return cell
    }
    
    // MARK: - VCConnectorIRegisterParticipantEventListener delegate
    
    func onParticipantJoined(_ participant: VCParticipant!) {
//        os_log("getId-------%@", log: .default, type: .default, participant.getId())
//        os_log("getName-------%@", log: .default, type: .default, participant.getName())
//        os_log("getUserId-------%@", log: .default, type: .default, participant.getUserId())
    }
    
    func onParticipantLeft(_ participant: VCParticipant!) {
    }
    
    func onDynamicParticipantChanged(_ participants: NSMutableArray!) {
//        os_log("participants-------%@", log: .default, type: .default, participants)
        VidyoManager.arrParticipants = participants as! [VCParticipant]
        
        DispatchQueue.main.async {
            self.lblTotalMember.text = String(VidyoManager.arrParticipants.count+1)
            self.tblViewObj.reloadData()
        }
    }
    
    func onLoudestParticipantChanged(_ participant: VCParticipant!, audioOnly: Bool) {        
    }
    
    // MARK: - VCConnectorIRegisterMessageEventListener
    
    func onChatMessageReceived(_ participant: VCParticipant!, chatMessage: VCChatMessage!) {
        
        DispatchQueue.main.async {
            
            let msg = String(chatMessage.body)
            
            if (!msg.isEmpty) {
                let chatInfo = ChatInfo(participantName: participant.getName(), chatMessage: msg, participantType: false)
                VidyoManager.arrChatMessages.append(chatInfo)
                
            }
        }
    }
}
