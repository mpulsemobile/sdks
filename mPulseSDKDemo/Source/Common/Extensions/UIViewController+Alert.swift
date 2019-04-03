//
//  UIViewController+Alert.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 13/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String) {
        alert(title: Constants.Alert.Error, message: message)
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, alertActions: [(Constants.Alert.Ok, nil)])
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, acceptMessage: String, acceptBlock: @escaping (UIAlertAction) -> (Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, alertActions: [(acceptMessage, acceptBlock)])
        self.present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, alertActions: [(text: String, action: ((UIAlertAction) -> (Void))?)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, alertActions: alertActions)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, alertActions: [(text: String, action: ((UIAlertAction) -> (Void))?)]) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        
        for (buttonText, buttonAction) in alertActions {
            if buttonAction != nil {
                let action = UIAlertAction(title: buttonText, style: .default) { (alertAction) -> Void in
                    buttonAction!(alertAction)
                }
                self.addAction(action)
            } else {
                let action = UIAlertAction(title: buttonText, style: .default)
                self.addAction(action)
            }
        }
    }
}


