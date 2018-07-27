//
//  CPAddMemberViewController.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework

class CPMemberViewController: UIViewController {
    
    @IBOutlet weak var alertLabel: UILabel!
    var isUpdating:Bool = false
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var memberidTextField: UITextField!
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    
    var memberDetails = [InputField]()
    // Fields in Member form
    var firstNameField = InputField("First Name", value: nil)
    var lastNameField = InputField("Last Name", value: nil)
    var emailField = InputField("Email", value: nil)
    var phoneField = InputField("Phone", value: nil)
    var listIDField = InputField("List ID", value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = isUpdating ? "Update member" : "Add new member"
        alertLabel.text = "**Member id or Email or Phone, at least one is required"
        
        if isUpdating == false {
            alertLabel.text = "**Email or Phone, at least one is required"
            headerView.removeFromSuperview()
            headerView = nil
            self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 1.0))
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.initializeMemberForm()
    }
    
    func initializeMemberForm() {
        memberDetails.append(contentsOf:[firstNameField, lastNameField, emailField, phoneField, listIDField])
    }
    
    @objc func doneTapped() {
        var otherAttributes = [String:String]()
        
        for i in  5..<memberDetails.count {
            let field = memberDetails[i]
            otherAttributes[field.label ?? "" ] = field.value 
        }
        
        for (key,value) in otherAttributes {
            if value.isEmpty == true {
                otherAttributes[key] = nil
            }
        }
        
        let member =  Member(firstName: firstNameField.value, lastName: lastNameField.value, email: emailField.value, phoneNumber: phoneField.value, otherAttributes: otherAttributes)
        self.setEmptyAttributesToNil(member:member)
        
        if isUpdating == true {
            ProgressIndicatorCommand(view: self.view).execute()
            var memberId:String?
            if memberidTextField.text?.isEmpty == true {
                memberId = nil
            } else {
                memberId = memberidTextField.text
            }
            MpulseControlPanel.shared().updateMember(withID: memberId, details: member, andList: listIDField.value, completionHandler: { (result, apiMessage, error) in
                ProgressIndicatorCommand(view: self.view).stopExecution()
                if (apiMessage != nil) {
                    AlertHelper().showAlert(title:"", message:apiMessage! , presentingController: self, buttonAction: nil)
                    return
                }
                else if (error != nil) {
                    AlertHelper().showAlert(title:"", message:error!.localizedDescription , presentingController: self, buttonAction: nil)
                }})
        } else {
            ProgressIndicatorCommand(view: self.view).execute()
            MpulseControlPanel.shared().addNewMember(member, toList:listIDField.value) { (result, apiMessage, error) in
                ProgressIndicatorCommand(view: self.view).stopExecution()
                if (apiMessage != nil) {
                    AlertHelper().showAlert(title:"", message:apiMessage! , presentingController: self, buttonAction: nil)
                } else if (error != nil) {
                    AlertHelper().showAlert(title:"", message:error!.localizedDescription , presentingController: self, buttonAction: nil)
                }
            }
        }
    }
    
    func setEmptyAttributesToNil(member:Member) {
        if member.email?.isEmpty == true {
            member.email = nil
        }
        if member.phoneNumber?.isEmpty == true {
            member.phoneNumber = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func memberIDFieldChanged(_ sender: UITextField) {
        self.updateDoneButtonState()
    }
    
    func updateDoneButtonState() {
        if isUpdating == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = memberidTextField.text?.isEmpty == false || emailField.value?.isEmpty == false || phoneField.value?.isEmpty == false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = emailField.value?.isEmpty == false || phoneField.value?.isEmpty == false
        }
    }
    
    @IBAction func newFieldAction(_ sender: UIButton) {
        let field = InputField(nil, value: nil)
        field.isNewField = true
        memberDetails.append(field)
        tableView.beginUpdates()
        tableView.insertRows(at: [
            IndexPath(row: memberDetails.count - 1, section: 0)
            ], with: .bottom)
        tableView.endUpdates()
    }
}

extension CPMemberViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberFieldCell", for: indexPath) as! MemberFieldCell
        let field = memberDetails[indexPath.row]
        cell.configureWithMemberDetails(field: field.label ?? "", value: field.value ?? "",placeholder: field.placeholder!, isNewField: field.isNewField!)
        cell.delegate = self
        return cell
    }
}

extension CPMemberViewController:MemberDelegate {
    func didChangeFieldLabel(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        if let row = indexPath?.row {
            let field = memberDetails[row]
            field.label = text
        }
    }
    
    func didChangeFieldValue(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        if let row = indexPath?.row {
            let field = memberDetails[row]
            field.value = text
        }
        self.updateDoneButtonState()
    }
}
