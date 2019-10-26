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
        (segue.destination as! LandingViewController).delegate = self
    }
    
    private func sendHomePageRequest(){
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL)!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "forward")!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "right")!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "reverse")!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "left")!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "stop")!) { (result) in
            
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
        Networking.sendGETRequest(withURL: URL(string: ViewController.baseURL + "berzerk")!) { (result) in
            
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

extension String {
    static var landingViewControllerSegue : String{
        get{
            return "LandingViewControllerSegue"
        }
    }
}

extension ViewController : LandingViewControllerDelegate {
    func didEnterIPAddress(_ IPAddress: String) {
        ViewController.baseURL += IPAddress + "/"
        statusLabel.text = "Connecting to server (\(ViewController.baseURL)) .."
        sendHomePageRequest()
    }
}
