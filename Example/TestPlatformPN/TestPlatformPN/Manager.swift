//
//  Manager.swift
//  TestPlatformPN
//
//  Created by Heena Dhawan on 28/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation

class Manager {
    static let shared = Manager()
    private init() { }
    func keyValuePairForNotificaion(deeplinkingParams: [AnyHashable : Any]) -> (title : String?, details: String?){
        if let pnDataModule = deeplinkingParams["otherAppKeyValuePairs"] as? [Any] {
            //Considering only 1 pair
            for each in pnDataModule{
                if let eachDict = each as? [String: String]{
                    return (eachDict["key"], eachDict["value"])
                }
            }
        }
        return (nil, nil)
    }
}
