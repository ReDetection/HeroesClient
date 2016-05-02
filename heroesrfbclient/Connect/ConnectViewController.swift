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

private enum ConnectionResult {
    case Error(NSError)
    case OK(RFBFramebufferedConnection)
}

class ConnectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var hostField: UITextField!
    @IBOutlet var portField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var connectionReference: RFBFramebufferedConnection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadLastCredentials()
        self.hostField.becomeFirstResponder()
        self.hostField.selectAll(nil)
    }

    @IBAction func connectTapped(sender: AnyObject) {
        self.saveCredentials()
        if let host = self.hostField.text, portText = self.portField.text {
            self.tryConnect(host, port: (portText as NSString).intValue, password: self.passwordField.text) { [weak self] result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .OK(let server):
                        AppState.sharedInstance.server = server
                        self?.view.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                        
                    case .Error(let error):
                        print ("\(error)")
                        let alert = UIAlertController(title: "\(error.code)", message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                        self?.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            }
        }
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
    
    private func tryConnect(host: String, port: Int32, password: String?, resultBlock: ((ConnectionResult)->())? ) {
        let config = RFBServerData()
        config.host = host
        config.port = port
        config.password = password
        
        var dispatch_once_token: dispatch_once_t = 0
        
        let server = RFBFramebufferedConnection(serverData: config)
        server.didUpdatedRect = { rect in
            server.didUpdatedRect = nil
            server.didErrorOccurred = nil
            dispatch_once(&dispatch_once_token) {
                resultBlock?(.OK(server))
            }
        }
        server.didErrorOccurred = { error in
            server.didUpdatedRect = nil
            server.didErrorOccurred = nil
            resultBlock?(.Error(error))
        }
        self.connectionReference = server
        server.connect()
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
