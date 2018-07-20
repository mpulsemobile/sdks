//
//  AlertHelper.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
import UIKit
class AlertHelper {
    func showAlert(title:String,message:String, presentingController:UIViewController, buttonAction:(()->Void)? ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler:  { (action) in
            buttonAction?()
        })
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            presentingController.present(alertController, animated: true, completion: nil)
        }
    }
}
