//
//  NetworkManager.swift
//  mPulseSDKDemo
//
//  Created by Deepanshi Gupta on 15/10/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

enum RequestResponse {
    case success(Any)
    case failure(RequestError)
}

struct RequestError: Error {
    var code: Int!
    var errorMessage: String!
}

struct NetworkManager {
    
        func getResponseForRequest(router: NetworkRouter, completion:@escaping (RequestResponse)->()) {
            let session = URLSession.shared
            var task: URLSessionTask?
            do {
                let request = try router.urlRequest()
                task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                    let httpResponse = response as! HTTPURLResponse
                    
                    if let _ = error {
                        let requestErr = NetworkError.getErrorFromResponse(httpResponse: httpResponse, errorData: data, error: error as NSError? ?? NSError())
                        completion(.failure(requestErr))
                    } else {
                        if let data = data, (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
                            do {
                                let responseJson = try JSONSerialization.jsonObject(with: data, options: [])
                                completion(.success(responseJson))
                            } catch let serializeErr {
                                print(serializeErr)
                            }
                        } else {
                            let requestErr = NetworkError.getErrorFromResponse(httpResponse: httpResponse, errorData: data, error: error as NSError? ?? NSError())
                            completion(.failure(requestErr))
                        }
                    }
                })
            } catch {
                completion(.failure(RequestError(code: NSURLErrorBadURL, errorMessage: error.localizedDescription)))
            }
            task?.resume()
        }
}
