//
//  ControlPanelLoginViewController.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework

class ControlPanelLoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginButtonClicked(_ sender: Any) {
        MpulseControlPanel.shared().logIn(withOauthUsername: usernameTextField.text!, andPassword: passwordTextField.text!) { (isSuccess, error) in
            if isSuccess == true && error == nil {
                let message = "refresh token: \(MpulseControlPanel.shared().refreshToken) "
                AlertHelper().showAlert(title:"Success", message:message , presentingController: self, buttonAction: {
                    let MainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
                    let controller = MainStoryboard.instantiateViewController(withIdentifier: "controlPanel")
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            } else {
                AlertHelper().showAlert(title:"Failure", message:error?.localizedDescription ?? "" , presentingController: self, buttonAction: nil)
            }
       }
    }
}
