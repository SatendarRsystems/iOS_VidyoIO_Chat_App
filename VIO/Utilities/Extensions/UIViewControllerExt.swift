//
//  UIViewControllerExt.swift
//  VIO
//
//  Summary: UIViewController extension component
//  Description: An extension of UIViewController for additional common methods.
//
//  Created by Arun Kumar on 27/09/18.
//  Copyright © 2018 R Systems. All rights reserved.
//

/**
 Summary:Used to display alert pop-up without delegate method
 Description:
 */
import Foundation
import UIKit
import os.log

extension UIViewController {
    
    //MARK: - Alert popups methods

    /**
     Used to display alert pop-up without delegate method
     */
    func alert(message: String, title: String = NSLocalizedString("Vidyo", comment: "")) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
