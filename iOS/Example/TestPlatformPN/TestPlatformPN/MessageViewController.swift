//
//  MessageViewController.swift
//  TestPlatformPN
//
//  Created by Heena Dhawan on 28/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
import UIKit
class MessageViewController: UIViewController {
    var strTitle: String?
    var details: String?
    @IBOutlet weak var lbldetails: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = strTitle
        self.navigationItem.title = strTitle
        lbldetails.text = details
        
    }
}
