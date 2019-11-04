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
    @IBOutlet weak var honkButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet var outletCollection: [UIButton]!
    
    private static var baseURL = "http://"
    
    private var isServerActive: Bool! {
        didSet{
            if isServerActive{
                outletCollection.forEach { (button) in
                    async {
                        button.isEnabled = true
                        button.setTitleColor(.label, for: .normal)
                    }
                }
            }else{
                outletCollection.forEach { (button) in
                    async {
                        button.isEnabled = false
                        button.setTitleColor(.lightGray, for: .disabled)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        async {
            self.performSegue(withIdentifier: .landingViewControllerSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! LandingViewController).onEntryOfIPAddress = { [unowned self] (IPAddress) in
            UserDefaults.standard.set(IPAddress as String, forKey: "IP")
            ViewController.baseURL += IPAddress + "/"
            self.statusLabel.text = "Connecting to server (\(ViewController.baseURL)) .."
            self.sendHomePageRequest()
        }
    }
    
    private func sendHomePageRequest(){
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL)!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async{
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "forward")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "right")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "reverse")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async{
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "left")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "stop")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                }
            }
        }
    }
    
    @IBAction func honkButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "honk")!) { (result) in
            
            switch result {
            case .success(let dict):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = dict["message"]! as? String
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.statusLabel.text = "Your next move?"
                    }
                }
                
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
            }
        }
    }
    
    @IBAction func berzerkButtonPressed(_ sender: UIButton) {
        sender.shrinkAndExpand()
        showSpinner()
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "berzerk")!) { (result) in
            
            switch result {
            case .failure(let error):
                self.async {
                    self.hideSpinner()
                    self.statusLabel.text = error.localizedDescription
                }
                
            case .success(let dict):
                self.async {
                    self.hideSpinner()
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

extension String {
    static var landingViewControllerSegue : String {
        get{
            return "LandingViewControllerSegue"
        }
    }
}
