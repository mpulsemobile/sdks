//
//  NetworkErrorManager.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

struct NetworkError {
    public static func getErrorFromResponse(httpResponse: HTTPURLResponse?, errorData: Data?, error:NSError) -> RequestError {
        if let response = httpResponse, let errData = errorData {
            return getErrorFromServer(httpResponse: response, errorData: errData)
        } else {
            return getOtherError(error: error)
        }
    }
    
    private static func getErrorFromServer(httpResponse: HTTPURLResponse, errorData: Data) -> RequestError {
        //let errorMSg = String(data: errorData, encoding: .utf8)
        
        if let errorJson = dataToJson(data: errorData) {
            return RequestError(code: httpResponse.statusCode, errorMessage: errorJson["message"] as? String)
        }
        return RequestError(code: httpResponse.statusCode, errorMessage: Constants.RequestDefaultError.UnknownError)
    }
    
    private static func getOtherError(error:NSError) -> RequestError{
        var errorMsg:String?
        switch (error.code) {
            
        case NSURLErrorNotConnectedToInternet:
            errorMsg = Constants.RequestDefaultError.ConnectivityProblem
            
        case NSURLErrorTimedOut:
            errorMsg = Constants.RequestDefaultError.RequestTimeout
            
        case NSURLErrorBadServerResponse:
            errorMsg = Constants.RequestDefaultError.BadRequest
            
        default:
            errorMsg = Constants.RequestDefaultError.UnknownError
        }
        
        return RequestError(code: error.code, errorMessage: errorMsg)
    }
    
    private static func dataToJson(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let serializeErr {
            print(serializeErr)
        }
        return nil
    }
}
