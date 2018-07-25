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
    // Fields in Member form
    var eventNameField = InputField("Event Name", value: nil)
    var scheduledOnField = InputField("Scheduled On", value: nil, placeholder:"YYYY-MM-DD HH:MM | +HH:MM")
    var scopeField = InputField("Evaluation Scope", value: nil, placeholder:"no_rule | with_rule | all")
    var timezoneField = InputField("Timezone", value: nil)
    var memberIDField = InputField("Member ID", value: nil)
    var correlationField = InputField("Correlation ID (optional)", value: nil)
    var listIDField = InputField("List ID", value: nil)
    
    var eventDetails = [InputField]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add new event"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.initializeEventForm()
    }
    
    func initializeEventForm() {
        eventDetails.append(contentsOf: [eventNameField,scheduledOnField, scopeField, timezoneField, memberIDField, correlationField, listIDField])
    }
    
    @objc func doneTapped() {
        var customAttributes = [String:String]()
        
        for i in  4..<eventDetails.count {
            let field = eventDetails[i]
            customAttributes[field.label ?? ""] = field.value
        }
        
        let event =  Event(name: eventNameField.value!,
                           scheduledOn: scheduledOnField.value!,
                           evaluationScope: scopeField.value!,
                           timezone: timezoneField.value!,
                           memberID: memberIDField.value!,
                           correlationID:correlationField.value,
                           customAttributes: customAttributes)
        ProgressIndicatorCommand(view: self.view).execute()
        MpulseControlPanel.shared().triggerEvent(event, inList: listIDField.value!) { (result, apiMessage, error) in
            ProgressIndicatorCommand(view: self.view).stopExecution()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func newFieldAction(_ sender: UIButton) {
        eventDetails.append(InputField(nil, value: nil))
        tableView.beginUpdates()
        tableView.insertRows(at: [
            IndexPath(row: eventDetails.count - 1, section: 0)
            ], with: .bottom)
        tableView.endUpdates()
    }
}

extension CPAddEventViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventDetails.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberFieldCell", for: indexPath) as! MemberFieldCell
        let field = eventDetails[indexPath.row]
        cell.configureWithMemberDetails(field: field.label ?? "", value: field.value ?? "", placeholder:field.placeholder!)
        cell.delegate = self
        return cell
    }
}

extension CPAddEventViewController:MemberDelegate {
    func didChangeFieldLabel(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = eventDetails[(indexPath?.row)!]
        field.label = text
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func didChangeFieldValue(_ cell: MemberFieldCell,text:String) {
        let indexPath = tableView.indexPath(for: cell)
        let field = eventDetails[(indexPath?.row)!]
        field.value = text
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        if (eventNameField.value?.isEmpty == false &&
            scheduledOnField.value?.isEmpty == false &&
           scopeField.value?.isEmpty == false &&
            timezoneField.value?.isEmpty == false &&
            memberIDField.value?.isEmpty == false && listIDField.value?.isEmpty == false ) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false

        }
    }
}
