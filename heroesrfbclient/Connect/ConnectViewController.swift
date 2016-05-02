//
//  ConnectViewController.swift
//  heroesrfbclient
//
//  Created by sbuglakov on 02/05/16.
//  Copyright © 2016 redetection. All rights reserved.
//

import UIKit

private let LAST_HOST_ADDRESS_KEY = "LAST_HOST_ADDRESS_KEY"
private let LAST_PORT_KEY = "LAST_PORT_KEY"
private let LAST_PASSWORD_KEY = "LAST_PASSWORD_KEY"

class ConnectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var hostField: UITextField!
    @IBOutlet var portField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadLastCredentials()
        self.hostField.becomeFirstResponder()
        self.hostField.selectAll(nil)
    }

    @IBAction func connectTapped(sender: AnyObject) {
        self.saveCredentials()
    }
    
    @IBAction func forgetTapped(sender: AnyObject) {
        self.clearCredentials()
        self.loadLastCredentials()
    }
    
    func loadLastCredentials() {
        self.hostField.text = NSUserDefaults.standardUserDefaults().stringForKey(LAST_HOST_ADDRESS_KEY)
        self.portField.text = NSUserDefaults.standardUserDefaults().stringForKey(LAST_PORT_KEY) ?? "5900"
        self.passwordField.text = NSUserDefaults.standardUserDefaults().stringForKey(LAST_PASSWORD_KEY)
    }
    
    func saveCredentials() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(self.hostField.text, forKey: LAST_HOST_ADDRESS_KEY)
        defaults.setObject(self.portField.text, forKey: LAST_PORT_KEY)
        defaults.setObject(self.passwordField.text, forKey: LAST_PASSWORD_KEY)
        defaults.synchronize()
    }
    
    func clearCredentials() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(LAST_HOST_ADDRESS_KEY)
        defaults.removeObjectForKey(LAST_PORT_KEY)
        defaults.removeObjectForKey(LAST_PASSWORD_KEY)
        defaults.synchronize()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === self.hostField {
            self.portField.becomeFirstResponder()
            self.portField.selectAll(nil)
        } else if textField === self.portField {
            self.passwordField.becomeFirstResponder()
            self.passwordField.selectAll(nil)
        } else if textField === self.passwordField {
            self.passwordField.resignFirstResponder()
            self.connectTapped(self)
        }
        return false
    }
    
}
