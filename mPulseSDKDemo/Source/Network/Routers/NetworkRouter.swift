//
//  NetworkRouter.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

protocol NetworkRouter {
    var route: (method: HTTPMethod, path: String, task: HTTPTask) { get }
    var baseURL: String { get }
    
    func urlRequest() throws -> URLRequest
}

extension NetworkRouter {
  
    var baseURL: String {
        return Constants.ApiBaseUrl
    }
    
    private var URL: URL {
        return Foundation.URL(string: (baseURL + route.path).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    }
    
    
    func urlRequest() throws -> URLRequest {
        var request = URLRequest(url: URL)
        request.httpMethod = route.method.rawValue
        do {
            switch route.task {
            case .dataTask:
                request.setValue(Constants.Request.AppJson, forHTTPHeaderField: Constants.Request.ContentType)
                
            case .dataTaskWithParameters(let bodyParameters, let encoding, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, encoding: encoding, urlParameters: urlParameters, request: &request)
                
            case .dataTaskWithParametersAndHeaders(let bodyParameters, let encoding, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, encoding: encoding, urlParameters: urlParameters, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?, encoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            try encoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}


//        Auth token
//
//        if let authToken = Defaults[.authorizationToken] {
//            urlRequest.setValue(authToken, forHTTPHeaderField: Constants.Request.Authorization)
//        }
//
//    func cancel()

