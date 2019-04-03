//
//  UIColor+Utilities.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 13/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
import UIKit
typealias ColorDef = UInt32


extension UIColor {
    
    static func errorColor() -> UIColor {
        return UIColor(0xFF3824)
    }
    
    // MARK: Custom Initializers
    convenience init(_ colorDef: ColorDef) {
        self.init(colorDef: colorDef)
    }
    
    convenience init(colorDef: ColorDef) {
        self.init(colorDef: colorDef, alpha: 1.0)
    }
    
    convenience init(colorDef: ColorDef, alpha: CGFloat) {
        let blue = CGFloat(colorDef & 0xff) / CGFloat(255)
        let green = CGFloat(colorDef >> 8 & 0xff) / CGFloat(255)
        let red = CGFloat(colorDef >> 16 & 0xff) / CGFloat(255)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
