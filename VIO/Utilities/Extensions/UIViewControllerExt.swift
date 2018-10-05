//
//  UIViewControllerExt.swift
//  VIO
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

import Foundation
import UIKit
import os.log

extension UIViewController {
    
    //MARK: - Alert popups methods

    func alert(message: String, title: String = NSLocalizedString("Vidyo", comment: "")) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertWithButtonAction(message: String, title: String = NSLocalizedString("Vidyo", comment: "")) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) {
            (action: UIAlertAction) in
            self.clickedBtnAlertOk()
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func clickedBtnAlertOk() {
        //Implement this delegate method in your view controller for OK button action
    }
}
