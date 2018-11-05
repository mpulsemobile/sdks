//
//  NSDate+Utilities.swift
//  TestPlatformPN
//
//  Created by Deepanshi Gupta on 30/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

extension Date {
    
    func getCurrentPNActionTime() -> String {
        return getDateStringAccordingToFormat(dateFormatString: "yyyy-MM-dd HH:mm:ss.SSSSSZZZZZ")!
    }
    
    func getDateStringAccordingToFormat(dateFormatString:String?) -> String? {
        if (dateFormatString == nil) {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatString
        return formatter.string(from: self)
    }
}
