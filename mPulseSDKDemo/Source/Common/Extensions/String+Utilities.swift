//
//  String+Utilities.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 13/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

//MARK: - Utilities
extension String {
    func isNumber() -> Bool {
        return self.rangeOfCharacter(from: NSCharacterSet.decimalDigits.inverted) == nil
    }
    
    func trimEverything() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: self)
    }
}


