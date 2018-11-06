//
//  MessageViewController.swift
//  TestPlatformPN
//
//  Created by Heena Dhawan on 28/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import Foundation
import UIKit
import MpulseFramework

class InboxViewController: UIViewController {
    var inboxView : MpulseInboxView!
    var activityIN : UIActivityIndicatorView!
    var lblNoUser : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Inbox"
        //Lable - User not logged in
        lblNoUser = UILabel(frame: self.view.frame)
        lblNoUser.text = "User Not Logged in"
        lblNoUser.textAlignment = .center
        self.view.addSubview(lblNoUser);
        //Inbox View for secure msg web view
        inboxView = MpulseHandler.shared().inboxView()
        inboxView.delegate = self
        inboxView.frame = self.view.frame
        self.view.addSubview(inboxView)
        //activity indicator
        activityIN = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) as UIActivityIndicatorView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadInboxNotification(_:)), name: Notification.Name("ReloadInbox"), object: nil)
        loadInbox()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ReloadInbox"), object: nil)
    }
    
    func loadInbox() {
        if let _ = UserDefaults.standard.value(forKey: "User") {
            self.inboxView.isHidden = false
            self.lblNoUser.isHidden = true
            if MpulseHandler.shared().appMemberId != nil {
                inboxView.loadInbox()
                showActivityIndicator()
            }
        }else{
            self.lblNoUser.isHidden = false
            self.inboxView.isHidden = true
        }
    }
    
    func showActivityIndicator(){
        activityIN.center = self.view.center
        activityIN.hidesWhenStopped = true
        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIN.startAnimating()
        self.view.addSubview(activityIN)
        inboxView.addSubview(activityIN)
    }
    
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        loadInbox()
    }
    
    
    
    @objc private func handleReloadInboxNotification(_ notification : NSNotification) {
        loadInbox()
    }
}

extension InboxViewController: MpulseInboxViewDelegate{
    func inboxViewDidStartLoading() {
        //        actInd.startAnimating()
    }
    func inboxViewDidFinishLoading() {
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        activityIN.stopAnimating()
    }
    func inboxViewDidFailLoadingWithError(_ error: Error) {
        print(error);
        activityIN.stopAnimating()
    }
}

