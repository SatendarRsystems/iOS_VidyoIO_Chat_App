//
//  BaseVC.swift
//  VIO
//
//  Summary: Base view controller Component
//  Description: It is a base class for all UIViewControllers.
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
}
