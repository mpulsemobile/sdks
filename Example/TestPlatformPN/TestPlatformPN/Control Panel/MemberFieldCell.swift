//
//  MemberFieldCell.swift
//  TestPlatformPN
//
//  Created by Rahul Verma on 20/07/18.
//  Copyright © 2018 mPulse. All rights reserved.
//

import UIKit
import MpulseFramework
protocol MemberDelegate {
    func didChangeFieldLabel(_ cell: MemberFieldCell,text:String)
    func didChangeFieldValue(_ cell: MemberFieldCell,text:String)
}

class MemberFieldCell: UITableViewCell {

    @IBOutlet weak var fieldLabelTextField: UITextField!
    @IBOutlet weak var fieldValueTextField: UITextField!
    var delegate:MemberDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureWithMemberDetails(field:String,value:String, placeholder:String, isNewField:Bool) {
        fieldLabelTextField.isUserInteractionEnabled = isNewField
        fieldLabelTextField.textColor = isNewField ? UIColor.blue : UIColor.black
        fieldLabelTextField.text  = field
        fieldValueTextField.text = value
        fieldValueTextField.placeholder = placeholder
    }
    
    @IBAction func fieldLabelChanged(_ sender: UITextField) {
                self.delegate?.didChangeFieldLabel(self, text: sender.text!)
    }
    @IBAction func fieldValueChanged(_ sender: UITextField) {
                        self.delegate?.didChangeFieldValue(self, text: (sender as AnyObject).text)

    }

}
