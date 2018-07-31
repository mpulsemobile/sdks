//
//  ProgressCommand.swift
//  ProgressIndicatorUsingCommandPattern
//
//  Created by Rahul Verma on 31/03/18.
//  Copyright © 2018 Quovantis. All rights reserved.
//

import Foundation
import UIKit
protocol Command {
    func execute()
    func stopExecution()
}

// contains receiver and function that is invoked on receiver
class ProgressIndicatorCommand:Command {
    let progressIndicator:ProgressIndicator
    let view:UIView
    
    init(progressIndicator: ProgressIndicator = DefaultProgressIndicator(), view:UIView){
        self.progressIndicator = progressIndicator
        self.view = view
    }
    
    func execute() {
        self.progressIndicator.load(on: self.view)
    }
    
    func stopExecution() {
        DispatchQueue.main.async {
            for view in self.view.subviews {
                if view is UIActivityIndicatorView || view.tag == 500 {
                    view.removeFromSuperview()
                    break
                }
            }
        }
    }
}

protocol ProgressIndicator {
    func load(on view:UIView)
}

class DefaultProgressIndicator:ProgressIndicator {
    func load(on view:UIView){
        view.endEditing(true)
        let viewCenter  = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        viewCenter.tag = 500
        viewCenter.layer.cornerRadius = 16
        viewCenter.clipsToBounds = true
        viewCenter.backgroundColor = .lightGray
        let activityIndicator =
            UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = viewCenter.center
        viewCenter.center = view.center
        viewCenter.addSubview(activityIndicator)
        view.addSubview(viewCenter)
        activityIndicator.startAnimating()
    }
}

