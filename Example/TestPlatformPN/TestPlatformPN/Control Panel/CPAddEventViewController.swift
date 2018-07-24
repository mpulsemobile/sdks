//
//  CPAddMemberViewController.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework

class CPAddEventViewController: UIViewController {
    
    @IBOutlet weak var tableView: TPKeyboardAvoidingTableView!
    var memberDetails:[InputField] = [InputField("Event Name", value: nil),InputField("Scheduled On", value: nil, placeholder:"YYYY-MM-DD HH:MM | +HH:MM"),InputField("Evaluation Scope", value: nil, placeholder:"no_rule | with_rule | all"),InputField("Timezone", value: nil),InputField("Member ID", value: nil), InputField("Correlation ID (optional)", value: nil),InputField("List ID (optional)", value: nil)]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add new event"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false

    }
    
    @objc func doneTapped() {
        var customAttributes = [String:String]()
        
        for i in  4..<memberDetails.count {
            let field = memberDetails[i]
            customAttributes[field.label ?? ""] = field.value
        }
        
        let event =  Event(name: memberDetails[0].value!,
                           scheduledOn: memberDetails[1].value!,
                           evaluationScope: memberDetails[2].value!,
                           timezone: memberDetails[3].value!,
                           memberID: memberDetails[4].value!,
                           correlationID:  memberDetails[5].value,
                           customAttributes: customAttributes)
      
        MpulseControlPanel.shared().triggerEvent(event, inList: memberDetails[8].value!) { (result, apiMessage, error) in
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension CPAddEventViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberFieldCell", for: indexPath) as! MemberFieldCell
        let field = memberDetails[indexPath.row]
        cell.configureWithMemberDetails(field: field.label ?? "", value: field.value ?? "", placeholder:field.placeholder!)
        cell.delegate = self
        return cell
    }
}

extension CPAddEventViewController:MemberDelegate {
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
        if (memberDetails[0].value?.isEmpty == false &&
            memberDetails[1].value?.isEmpty == false &&
            memberDetails[2].value?.isEmpty == false &&
            memberDetails[3].value?.isEmpty == false &&
            memberDetails[4].value?.isEmpty == false && memberDetails[8].value?.isEmpty == false ) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false

        }
    }
}
