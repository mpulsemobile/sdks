//
//  ForgotPasswordViewController.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 13/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailField: UITextField!
    
    //MARK: - UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Actions
    @IBAction func forgotPasswordAction(sender: UIButton) {
        view.endEditing(true)
        guard validateAllFields() else {
            return
        }
        newPasswordRequest()
    }
    
    
    //MARK: - Private Methods
    private func initialSetup() {
    }
    
    
    private func validateAllFields() -> Bool {
        var errMsg: String
        guard emailField.text?.trimEverything().isEmpty == false else {
            errMsg = Constants.ForgotPasswordValidation.EmptyEmail
            return false
        }
        
        guard emailField.text?.trimEverything().isValidEmail() == false else {
            errMsg = Constants.ForgotPasswordValidation.ValidEmail
            return false
        }
        
        return true
    }
    
    private func newPasswordRequest() {
        //API call
    }
}

