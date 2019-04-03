//
//  Constants.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 22/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

struct Constants {
    
    static let ApiBaseUrl = "https://meet.stage.greenjobinterview.net/api/"
//    static let ApiBaseUrl = Bundle.main.infoDictionary?["APIBaseUrl"] as! String
    static let EmptyString    = ""

    struct Request {
        static let ContentType        = "Content-Type"
        static let AppURLEncoded      = "application/x-www-form-urlencoded; charset=utf-8"
        static let AppJson            = "application/json"
    }
    
    struct RequestDefaultError {
        static let ConnectivityProblem = "There seems to be a connectivity problem. Please check your data connectivity."
        static let UnknownError        = "There seems to be some problem, we are not able to complete your request right now. Please try again later."
        static let RequestTimeout      = "There seems to be request timeout, we are not able to complete your request right now. Please try again later."
        static let BadRequest          = "There seems to be some bad request, we are not able to complete your request right now. Please try again later."
    }
    
    struct LoginValidation {
        static let EmptyName            = "Please provide a Name"
        static let EmptyPassword        = "Please provide a Password"
    }
    
    struct SignupValidation {
        static let EmptyFirstName       = "Please provide a First Name"
        static let EmptyLastName        = "Please provide a Last Name"
        static let EmptyEmail           = "Please provide an Email"
        static let EmptyPhone           = "Please provide a Phone"
        static let ValidEmail           = "Please provide an Valid Email"
        static let EmptyPassword        = "Please provide a Password"
    }
    
    struct  ForgotPasswordValidation {
        static let EmptyEmail            = "Please provide an Email"
        static let ValidEmail            = "Please provide an Valid Email"
    }
    
    struct Alert {
        static let Ok       = "Ok"
        static let Error    = "Error"
    }
}
