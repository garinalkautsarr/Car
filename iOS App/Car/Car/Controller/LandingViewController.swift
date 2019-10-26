//
//  LandingViewController.swift
//  Car
//
//  Created by Manas Sharma on 10/26/19.
//  Copyright © 2019 Manas. All rights reserved.
//

import UIKit

class LandingViewController : UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var onEntryOfIPAddress: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        textField.becomeFirstResponder()
        textField.returnKeyType = .done
        textField.delegate = self
        
        isModalInPresentation = true
        view.backgroundColor = .systemBackground
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.label.cgColor
        layer.frame = CGRect(x: 0, y: textField.frame.size.height, width: textField.frame.size.width, height: 1)
        textField.layer.addSublayer(layer)
    }
}

extension LandingViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == nil || textField.text!.isEmpty {
            return false
        }
        onEntryOfIPAddress?(textField.text!)
        dismiss(animated: true)
        return true
    }
}
