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
        let alert = UIAlertController(title: "Control Panel", message: "Please Select an Action", preferredStyle: .actionSheet)
        let MainStoryboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        alert.addAction(UIAlertAction(title: "Add Member", style: .default , handler:{ (UIAlertAction)in
        
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "addMember")
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Update Member", style: .default , handler:{ (UIAlertAction)in
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "addMember") as! CPAddMemberViewController
            controller.isUpdating = true
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Trigger Event", style: .default, handler:{ (UIAlertAction)in
            let controller = MainStoryboard.instantiateViewController(withIdentifier: "addEvent")
            self.navigationController?.pushViewController(controller, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
