//
//  URLParameterEncoder.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else { throw EncodingError.missingURL  }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: Constants.Request.ContentType) == nil {
            urlRequest.setValue(Constants.Request.AppURLEncoded, forHTTPHeaderField: Constants.Request.ContentType)
        }
    }
}
