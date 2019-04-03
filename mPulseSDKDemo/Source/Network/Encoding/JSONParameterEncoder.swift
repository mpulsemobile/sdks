//
//  JSONParameterEncoder.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: Constants.Request.ContentType) == nil {
                urlRequest.setValue(Constants.Request.AppJson, forHTTPHeaderField: Constants.Request.ContentType)
            }
        }catch {
            throw EncodingError.encodingFailed
        }
    }
}
