//
//  InputField.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 24/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
class InputField {
    var label:String?
    var value:String?
    var placeholder:String?
    init(_ label:String?, value:String?,placeholder:String? = "--") {
        self.label = label
        self.value = value
        self.placeholder = placeholder
    }
}
