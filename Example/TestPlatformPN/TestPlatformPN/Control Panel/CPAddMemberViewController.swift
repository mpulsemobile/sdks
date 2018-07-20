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
    var label:String
    var value:String
    init(_ label:String, value:String) {
        self.label = label
        self.value = value
    }
}

class CPAddMemberViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var memberDetails:[Field] = [Field("First Name", value: ""),Field("Last Name", value: ""),Field("Email", value: ""),Field("Phone", value: "")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add new member"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    }
    
    @objc func doneTapped() {
        var otherAttributes = [String:String]()
        
        for i in  4..<memberDetails.count {
            let field = memberDetails[i]
            otherAttributes[field.label] = field.value
        }
       let member =  MpulseControlPanel.shared().createMember(withFirstName: memberDetails[0].value, lastName: memberDetails[1].value, email: memberDetails[2].value, phoneNumber: memberDetails[3].value, otherAttributes: otherAttributes)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newFieldAction(_ sender: UIButton) {
        memberDetails.append(Field("", value: ""))
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
        cell.configureWithMemberDetails(field: field.label, value: field.value)
        cell.delegate = self
        return cell
    }
}

extension CPAddMemberViewController:MemberDelegate {
    func didChangeFieldLabel(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = memberDetails[(indexPath?.row)!]
        field.label = text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func didChangeFieldValue(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = memberDetails[(indexPath?.row)!]
        field.value = text
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
