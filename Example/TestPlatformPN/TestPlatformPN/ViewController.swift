//
//  ViewController.swift
//  TestPlatformPN
//
//  Created by Heena Dhawan on 13/03/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework

enum LinkingType:String {
    case openApp = "Open_App"
    case secureMsg = "Open_Appmail_Message"
    case keyValue = "Open_Other"
}

class ViewController: UIViewController {
    
    @IBOutlet weak var lblToken: UILabel!
    @IBOutlet weak var txtFieldAppMemberId: UITextField!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    var details: String?
    var strTitle: String?
    var activityIN : UIActivityIndicatorView!
    
    @IBAction func getToken(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let deviceTokenFromDelegate = appDelegate.deviceTokenVal;
        lblToken.text = deviceTokenFromDelegate
        view.endEditing(true)
        if(deviceTokenFromDelegate != nil){
            pnRegister(deviceToken: deviceTokenFromDelegate!);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        checkUser()
        addActivityIndicator()
    }
    
    func addActivityIndicator(){
        activityIN = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) as UIActivityIndicatorView
        activityIN.center = self.view.center
        activityIN.hidesWhenStopped = true
        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIN)
    }
    
    func checkUser(){
        if let user = UserDefaults.standard.string(forKey: "User"){
            self.lblMessage.text = "Welcome \(user)"
            self.lblMessage.textColor = .black
            self.txtFieldAppMemberId.isHidden = true
            self.btnLogout.isHidden = false
            self.btnRegister.isHidden = true
            if(MpulseHandler.shared().appMemberId == nil){
                MpulseHandler.shared().configure(user)
            }
        }else{
            self.lblMessage.text = "Enter app memberId and click Register"
            self.lblMessage.textColor = .black
            self.txtFieldAppMemberId.isHidden = false
            self.btnLogout.isHidden = true
            self.btnRegister.isHidden = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUnreadMsgCount()
    }
    
    func getUnreadMsgCount(){
        if MpulseHandler.shared().appMemberId != nil && (UserDefaults.standard.value(forKey: "User") != nil){
            MpulseHandler.shared().getInboxMessageCount { (dict, err) in
                if let dictionary = dict as? [String: String], let unread = dictionary["unread"]{
                    DispatchQueue.main.async {
                        self.tabBarController?.tabBar.items?[1].badgeValue = unread
                    }
                }
            }
        }
    }
    
    func pnRegister(deviceToken: String){
        if let text = txtFieldAppMemberId.text {
            activityIN.startAnimating()
            MpulseHandler.shared().configure(text)
            if MpulseHandler.shared().appMemberId != nil{
                MpulseHandler.shared().registerForPushNotification(withDeviceToken: deviceToken, completionHandler: { (res, msg, err) in
                    DispatchQueue.main.async {
                        self.activityIN.stopAnimating()
                    }
                    if(err == nil){
                        
                        if res.rawValue == Success.rawValue{
                            UserDefaults.standard.set(text, forKey: "User")
                            DispatchQueue.main.async {
                                self.checkUser()
                            }
                            self.getUnreadMsgCount()
                        }else{
                            DispatchQueue.main.async {
                                self.lblMessage.text = msg
                                self.lblMessage.textColor = .red
                            }
                        }
                    }else{
                        if let e = err{
                            print(e.localizedDescription)
                        }
                        
                    }
                })
                
            }
        }else{
            self.lblMessage.text = "Please enter app member Id"
            self.lblMessage.textColor = .red
        }
    }
    
    func handleRemoteNotification(_ notification: [AnyHashable: Any]) {
        trackPushNotificationOpened(notification)

        //Handling deep linking parameters in push notification
        if let deeplinkingParams = notification["deepLinkingParameters"] as? [AnyHashable : Any] ,
            let linkingType = deeplinkingParams["linkingType"] as? String {
            let appLinkingType = LinkingType(rawValue: linkingType)
            switch appLinkingType! {
            case LinkingType.openApp:
                break
            case LinkingType.secureMsg:
                tabBarController?.selectedIndex = 1
                NotificationCenter.default.post(name: Notification.Name("ReloadInbox"), object: nil)
            case LinkingType.keyValue:
                tabBarController?.selectedIndex = 0
                let (strTitle, strDetails) = Manager.shared.keyValuePairForNotificaion(deeplinkingParams: deeplinkingParams)
                self.strTitle = strTitle
                self.details = strDetails
                performSegue(withIdentifier: "messageSegue", sender: nil)
            }
        }
    }
    
    func trackPushNotificationOpened(_ notification: [AnyHashable: Any]) {
        //Call SDK method to track push notification opened
        guard let pnInfo = notification["aps"] as? [AnyHashable : Any], let trackingId = pnInfo["trackingId"] as? String  else {
            print("Tracking Id missing in push notification. Contact support.");
            return
        }
        
        MpulseHandler.shared().trackPushNotificationOpened(withTrackingId: trackingId, deliveryTimeStamp: Date().getCurrentPNActionTime(), actionTimeStamp: Date().getCurrentPNActionTime(), completionHandler: { (res, apiMsg, error) in
            DispatchQueue.main.async {
                if(error == nil){
                    AlertHelper().showAlert(title:"PN Tracking Success", message:"Push notification tracked successfully.", presentingController: self, buttonAction: nil)
                    print(error?.localizedDescription ?? "")
                    print(apiMsg ?? "")
                    print("Push notification tracked.");
                } else {
                    AlertHelper().showAlert(title:"PN Tracking Error", message:error?.localizedDescription ?? "" , presentingController: self, buttonAction: nil)
                    print(error?.localizedDescription ?? "")
                    print(apiMsg ?? "")
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageSegue" {
            if let controller = segue.destination as? MessageViewController{
                controller.strTitle = self.strTitle
                controller.details = self.details
            }
        }
    }
    @IBAction func logoutUser(_ sender: Any) {
        if let _ = UserDefaults.standard.value(forKey: "User"), let appDelegate = UIApplication.shared.delegate as? AppDelegate, let deviceTokenFromDelegate = appDelegate.deviceTokenVal{
            activityIN.startAnimating()
            MpulseHandler.shared().unregisterForPushNotification(withDeviceToken: deviceTokenFromDelegate, completionHandler: { (res, apiMsg, error) in
                DispatchQueue.main.async {
                    self.activityIN.stopAnimating()
                    self.tabBarController?.tabBar.items?[1].badgeValue = nil
                }
                if(error == nil){
                    DispatchQueue.main.async {
                        UserDefaults.standard.removeObject(forKey: "User");
                        self.checkUser()
                    }
                }
            })
        }
    }
}

// Put this piece of code anywhere you like
extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
