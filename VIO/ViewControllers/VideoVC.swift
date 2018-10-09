//
//  VideoVC.swift
//  VIO
//
//  Created by Arun Kumar on 08/10/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

    @IBOutlet var viewVideo: UIView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        VidyoManager.sharedInstance.switchOffCamera(false)
        VidyoManager.sharedInstance.switchOffMic(false)
        VidyoManager.sharedInstance.switchOffSpeaker(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        VidyoManager.sharedInstance.switchOffCamera(true)
        VidyoManager.sharedInstance.switchOffMic(true)
        VidyoManager.sharedInstance.switchOffSpeaker(true)
    }
        
    @IBAction func clickedBtnChat(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clickedBtnCameraSwitch(_ sender: Any) {
    }
    @IBAction func clickedBtnCamera(_ sender: Any) {
    }
    @IBAction func clickedBtnMic(_ sender: Any) {
    }
}
