//
//  RegisterViewController.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 13/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: - UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Actions
    @IBAction func signupAction(sender: UIButton) {
        view.endEditing(true)
        guard validateAllFields() else {
            return
        }
        memberSignup()
    }
    
    //MARK: - Private Methods
    private func initialSetup() {
    }
    
    private func validateAllFields() -> Bool {
        var errMsg: String
        guard firstNameField.text?.trimEverything().isEmpty == false else {
            errMsg = Constants.SignupValidation.EmptyFirstName
            return false
        }
        guard lastNameField.text?.trimEverything().isEmpty == false else {
            errMsg = Constants.SignupValidation.EmptyLastName
            return false
        }
        guard phoneField.text?.trimEverything().isEmpty == false else {
            errMsg = Constants.SignupValidation.EmptyPhone
            return false
        }
        guard emailField.text?.trimEverything().isEmpty == false else {
            errMsg = Constants.SignupValidation.EmptyEmail
            return false
        }
        guard emailField.text?.trimEverything().isValidEmail() == false else {
            errMsg = Constants.SignupValidation.EmptyEmail
            return false
        }
        guard passwordField.text?.trimEverything().isEmpty == false  else {
            errMsg = Constants.SignupValidation.EmptyPassword
            return false
        }
        
        return true
    }
    
    
    private func memberSignup() {
        //API call
        
        //On success
    }
    
}



