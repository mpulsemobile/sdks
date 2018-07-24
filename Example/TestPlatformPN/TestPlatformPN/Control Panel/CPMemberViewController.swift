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
    var memberDetails:[InputField] = [InputField("First Name", value: nil),InputField("Last Name", value: nil),InputField("Email", value: nil),InputField("Phone", value: nil)]
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
    }
    
    @objc func doneTapped() {
        var otherAttributes = [String:String]()
        
        for i in  4..<memberDetails.count {
            let field = memberDetails[i]
            otherAttributes[field.label ?? "" ] = field.value 
        }
        let member =  Member(firstName: memberDetails[0].value, lastName: memberDetails[1].value, email: memberDetails[2].value, phoneNumber: memberDetails[3].value, otherAttributes: otherAttributes)
        if isUpdating == true {
            MpulseControlPanel.shared().updateMember(withID: memberidTextField.text ?? nil, details: member, andList: nil, completionHandler: { (result, apiMessage, error) in
                
            })
        } else {
            MpulseControlPanel.shared().addNewMember(member, toList: nil) { (result, apiMessage, error) in
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func memberIDFieldChanged(_ sender: UITextField) {
        if isUpdating == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = memberidTextField.text?.isEmpty == false || memberDetails[2].value?.isEmpty == false || memberDetails[3].value?.isEmpty == false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled =  memberDetails[2].value?.isEmpty == false || memberDetails[3].value?.isEmpty == false
        }
    }
    
    
    @IBAction func newFieldAction(_ sender: UIButton) {
        memberDetails.append(InputField(nil, value: nil))
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
        cell.configureWithMemberDetails(field: field.label ?? "", value: field.value ?? "",placeholder: field.placeholder!)
        cell.delegate = self
        return cell
    }
}

extension CPMemberViewController:MemberDelegate {
    func didChangeFieldLabel(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = memberDetails[(indexPath?.row)!]
        field.label = text
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func didChangeFieldValue(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = memberDetails[(indexPath?.row)!]
        field.value = text
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if isUpdating == true {
            self.navigationItem.rightBarButtonItem?.isEnabled = memberidTextField.text?.isEmpty == false || memberDetails[2].value?.isEmpty == false || memberDetails[3].value?.isEmpty == false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled =  memberDetails[2].value?.isEmpty == false || memberDetails[3].value?.isEmpty == false
        }
        
    }
}
