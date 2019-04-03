//
//  LoginViewController.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 10/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: - UIViewController LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Actions
    @IBAction func loginAction(sender: UIButton) {
        view.endEditing(true)
        guard validateAllFields() else {
            return
        }
        memberLogin()
    }

    //MARK: - Private Methods
    private func initialSetup() {
    }
    
    private func validateAllFields() -> Bool {
        var nameErrMsg, passErrMsg: String
        guard nameField.text?.trimEverything().isEmpty == false else {
            nameErrMsg = Constants.LoginValidation.EmptyName
            return false
        }
        
        guard passwordField.text?.trimEverything().isEmpty == false  else {
            passErrMsg = Constants.LoginValidation.EmptyPassword
            return false
        }
        
        return true
    }
    
    
    private func memberLogin() {
        //API call
        
        //On success
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = mainStoryBoard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarViewController
    }
    
}

//MARK: - UITextField Delegate
extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            passwordField.becomeFirstResponder()
        }
        return true
    }
}

