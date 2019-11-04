//
//  LandingViewController.swift
//  Car
//
//  Created by Manas Sharma on 10/26/19.
//  Copyright © 2019 Manas. All rights reserved.
//

import UIKit

class LandingViewController : UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var onEntryOfIPAddress: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI(){
        headerLabel.underline()
        
        textField.becomeFirstResponder()
        textField.returnKeyType = .go
        textField.delegate = self
        
        presentationController?.delegate = self
        
        isModalInPresentation = true
        view.backgroundColor = .systemBackground
        
        let layer = CALayer()
        layer.backgroundColor = UIColor.label.cgColor
        layer.frame = CGRect(x: 0, y: textField.frame.size.height, width: textField.frame.size.width, height: 1)
        textField.layer.addSublayer(layer)
        
        textField.text = UserDefaults.standard.string(forKey: "IP")
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

extension LandingViewController : UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showSingleOptionAlert(title: nil, message: "Please enter IP Address of the NodeMCU server to begin.", buttonStyle: .default, buttonTitle: "Ok", block: nil)
    }
}
