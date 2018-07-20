//
//  CPWelcomeViewCotroller.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit

class CPWelcomeViewCotroller: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Welcome"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Add Member", style: .default , handler:{ (UIAlertAction)in

        }))
        
        alert.addAction(UIAlertAction(title: "Update Member", style: .default , handler:{ (UIAlertAction)in

        }))
        
        alert.addAction(UIAlertAction(title: "Trigger Event", style: .default, handler:{ (UIAlertAction)in

        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
