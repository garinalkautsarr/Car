//
//  ViewController.swift
//  Car
//
//  Created by Manas Sharma on 10/26/19.
//  Copyright © 2019 Manas. All rights reserved.
//

import UIKit

class ViewController : UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var berzerkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet var outletCollection: [UIButton]!
    
    private var isServerActive: Bool! {
        didSet{
            if !isServerActive{
                outletCollection.forEach { (button) in
                    async {
                        button.isEnabled = false
                        button.setTitleColor(.lightGray, for: .disabled)
                    }
                }
            }else{
                outletCollection.forEach { (button) in
                    async {
                        button.isEnabled = true
                        button.setTitleColor(.label, for: .normal)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendHomePageRequest()
    }
    
    private func sendHomePageRequest(){
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async{
                    self.statusLabel.text = error.localizedDescription
                }
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/forward")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/right")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/reverse")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async{
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/left")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/stop")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func berzerkButtonPressed(_ sender: UIButton) {
        Networking.sendGETRequest(withURL: URL(string: "http://192.168.1.12/berzerk")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.statusLabel.text = dict["message"]! as? String
                }
                self.isServerActive = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    self.isServerActive = true
                    self.statusLabel.text = "Berzerk mode over."
                }
            }
        }
    }
    
}

extension UIViewController {
    func async(block: @escaping () -> Void){
        DispatchQueue.main.async {
            block()
        }
    }
}
