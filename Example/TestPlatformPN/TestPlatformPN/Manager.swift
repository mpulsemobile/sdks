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
    func handleNotificaion(userInfo: [AnyHashable : Any]) -> (title : String?, details: String?){
        if let pnData = userInfo["deepLinkingParameters"] as? [AnyHashable : Any] ,
            let pnDataModule = pnData["otherAppKeyValuePairs"] as? [Any] {
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
