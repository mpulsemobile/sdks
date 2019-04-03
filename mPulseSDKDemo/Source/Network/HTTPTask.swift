//
//  HTTPTask.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    
    case dataTask
    
    case dataTaskWithParameters(bodyParameters: Parameters?,
        encoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case dataTaskWithParametersAndHeaders(bodyParameters: Parameters?,
        encoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
    // case download, upload...etc
}
