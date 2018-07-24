//
//  CPAddMemberViewController.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework
class Field {
    var label:String?
    var value:String?
    var placeholder:String?
    init(_ label:String?, value:String?,placeholder:String? = "--") {
        self.label = label
        self.value = value
        self.placeholder = placeholder
    }
}

class CPAddMemberViewController: UIViewController {
    
    var isUpdating:Bool = false
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var memberidTextField: UITextField!
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    var memberDetails:[Field] = [Field("First Name", value: nil),Field("Last Name", value: nil),Field("Email", value: nil),Field("Phone", value: nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = isUpdating ? "Update member" : "Add new member"
        if isUpdating == false {
            headerView.removeFromSuperview()
            headerView = nil
            self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: 1.0))
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
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
    
    @IBAction func newFieldAction(_ sender: UIButton) {
        memberDetails.append(Field(nil, value: nil))
        tableView.beginUpdates()
        tableView.insertRows(at: [
            IndexPath(row: memberDetails.count - 1, section: 0)
            ], with: .bottom)
        tableView.endUpdates()
    }
}

extension CPAddMemberViewController:UITableViewDataSource {
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

extension CPAddMemberViewController:MemberDelegate {
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
    }
}
