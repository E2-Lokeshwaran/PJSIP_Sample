/*
 * Copyright (C) 2012-2012 Teluu Inc. (http://www.teluu.com)
 * Contributed by Emre Tufekci (github.com/emretufekci)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

//import UIKit
//
//var vc_inst: ViewController! = nil;
//
//func acc_listener_swift(status: Bool) {
//    DispatchQueue.main.async () {
//        vc_inst.updateAccStatus(status: status);
//    }
//}
//
//class ViewController: UIViewController {
//    
//    // Status Label
//    @IBOutlet weak var statusLabel: UILabel!
//    
//    // Sip settings Text Fields
//    @IBOutlet weak var sipIpTField: UITextField!
//    @IBOutlet weak var sipPortTField: UITextField!
//    @IBOutlet weak var sipUsernameTField: UITextField!
//    @IBOutlet weak var sipPasswordTField: UITextField!
//
//    @IBOutlet weak var loginButton: UIButton!
//    @IBOutlet weak var logoutButton: UIButton!
//
//    //Destination Uri to Making outgoing call
//    @IBOutlet weak var sipDestinationUriTField: UITextField!
//
//    var accStatus: Bool!
//    //var accStatus: Bool = false
//    
//        //property to store login details
//    var loginCredentials: [String: String]?
//
//
//    func updateAccStatus(status: Bool) {
//        accStatus = status;
//        if (status) {
//            statusLabel.text = "Reg Status: REGISTERED"
//            loginButton.isEnabled = false;
//            logoutButton.isEnabled = true;
//        } else {
//            statusLabel.text = "Reg Status: NOT REGISTERED"
//            loginButton.isEnabled = true;
//            logoutButton.isEnabled = false;
//        }
//    }
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        vc_inst = self;
//                
//        CPPWrapper().createAccountWrapper(sipUsernameTField.text,
//                                          sipPasswordTField.text,
//                                          sipIpTField.text,
//                                          sipPortTField.text)
//
//        //Done button to the keyboard
//        sipIpTField.addDoneButtonOnKeyboard()
//        sipPortTField.addDoneButtonOnKeyboard()
//        sipUsernameTField.addDoneButtonOnKeyboard()
//        sipPasswordTField.addDoneButtonOnKeyboard()
//        sipDestinationUriTField.addDoneButtonOnKeyboard()
//    }
//    
//    
//    //---- DEV CODE ----
//    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        
////        vc_inst = self
////        
////        // Load saved credentials if they exist
////        loadLoginCredentials()
////        
////        // Set up text fields
////        setupTextFields()
////        
////        // Add observers for app state changes
////        addAppStateObservers()
////        
////        // Attempt to log in if we have saved credentials
////        if let credentials = loginCredentials {
////            attemptLogin(with: credentials)
////        }
////    }
////    
////    deinit {
////        // Remove observers when the view controller is deallocated
////        NotificationCenter.default.removeObserver(self)
////    }
////    
////    func updateAccStatus(status: Bool) {
////        accStatus = status
////        if status {
////            statusLabel.text = "Reg Status: REGISTERED"
////            loginButton.isEnabled = false
////            logoutButton.isEnabled = true
////        } else {
////            statusLabel.text = "Reg Status: NOT REGISTERED"
////            loginButton.isEnabled = true
////            logoutButton.isEnabled = false
////        }
////    }
////    
////    func setupTextFields() {
////        [sipIpTField, sipPortTField, sipUsernameTField, sipPasswordTField, sipDestinationUriTField].forEach { $0?.addDoneButtonOnKeyboard() }
////    }
////    
////    func addAppStateObservers() {
////        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
////        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
////    }
////    
////    @objc func appMovedToBackground() {
////        // Save login state and credentials when app moves to background
////        if accStatus {
////            saveLoginCredentials()
////        }
////    }
////    
////    @objc func appMovedToForeground() {
////        // Check login status and attempt to log in if necessary
////        if !accStatus, let credentials = loginCredentials {
////            attemptLogin(with: credentials)
////        }
////    }
////    
////    func saveLoginCredentials() {
////        loginCredentials = [
////            "username": sipUsernameTField.text ?? "",
////            "password": sipPasswordTField.text ?? "",
////            "ip": sipIpTField.text ?? "",
////            "port": sipPortTField.text ?? ""
////        ]
////        UserDefaults.standard.set(loginCredentials, forKey: "SIPLoginCredentials")
////    }
////    
////    func loadLoginCredentials() {
////        loginCredentials = UserDefaults.standard.dictionary(forKey: "SIPLoginCredentials") as? [String: String]
////        if let credentials = loginCredentials {
////            sipUsernameTField.text = credentials["username"]
////            sipPasswordTField.text = credentials["password"]
////            sipIpTField.text = credentials["ip"]
////            sipPortTField.text = credentials["port"]
////        }
////    }
////    
////    func attemptLogin(with credentials: [String: String]) {
////        CPPWrapper().createAccountWrapper(
////            credentials["username"],
////            credentials["password"],
////            credentials["ip"],
////            credentials["port"]
////        )
////    }
//        
//    //Refresh Button
//    @IBAction func refreshStatus(_ sender: UIButton) 
//    {
//    }
//    
//    //Login Button
//    @IBAction func loginClick(_ sender: UIButton) 
//    {
//        //Check user already logged in. && Form is filled
//        if (//CPPWrapper().registerStateInfoWrapper() == false &&
//            !sipUsernameTField.text!.isEmpty &&
//            !sipPasswordTField.text!.isEmpty &&
//            !sipIpTField.text!.isEmpty &&
//            !sipPortTField.text!.isEmpty)
//        {
//            //Register to the user
//            CPPWrapper().createAccountWrapper(
//                sipUsernameTField.text,
//                sipPasswordTField.text,
//                sipIpTField.text,
//                sipPortTField.text)
//
//        } 
//        
//        else
//        {
//            let alert = UIAlertController(title: "SIP SETTINGS ERROR", message: "Please fill the form / Logout", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                    case .default:
//                    print("default")
//                    
//                    case .cancel:
//                    print("cancel")
//                    
//                    case .destructive:
//                    print("destructive")
//                    
//                @unknown default:
//                    fatalError()
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//        
//        
////        if !sipUsernameTField.text!.isEmpty &&
////           !sipPasswordTField.text!.isEmpty &&
////           !sipIpTField.text!.isEmpty &&
////           !sipPortTField.text!.isEmpty {
////            
////            attemptLogin(with: [
////                "username": sipUsernameTField.text!,
////                "password": sipPasswordTField.text!,
////                "ip": sipIpTField.text!,
////                "port": sipPortTField.text!
////            ])
//            
////            saveLoginCredentials()
////        } else {
////            showAlert(title: "SIP SETTINGS ERROR", message: "Please fill the form / Logout")
////        }
//    }
//    
//    //Logout Button
//    @IBAction func logoutClick(_ sender: UIButton) 
//    {
//        /**
//        Only unregister from an account.
//         */
//        //Unregister
//        CPPWrapper().unregisterAccountWrapper()
//        loginCredentials = nil
//        UserDefaults.standard.removeObject(forKey: "SIPLoginCredentials")
//    }
//
//    //Call Button
//    @IBAction func callClick(_ sender: UIButton)
//    {
//        if (accStatus) 
//        {
//            print("Destination caller -->",sipDestinationUriTField!)
//            let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "outgoingCallVC") as! OutgoingViewController
//            vcToPresent.outgoingCallId = sipDestinationUriTField.text ?? "<SIP-NUMBER>"
//            self.present(vcToPresent, animated: true, completion: nil)
//        } 
//        else
//        {
//            
//            let alert = UIAlertController(title: "Outgoing Call Error", message: "Please register to be able to make call", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                switch action.style{
//                    case .default:
//                    print("default")
//                    
//                    case .cancel:
//                    print("cancel")
//                    
//                    case .destructive:
//                    print("destructive")
//                    
//                @unknown default:
//                    fatalError()
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
//            
//            showAlert(title: "Outgoing Call Error", message: "Please register to be able to make call")
//            
//            
//        }
//
//    }
//    
//    
//    func showAlert(title: String, message: String)
//    {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//}


import UIKit

var vc_inst: ViewController! = nil

func acc_listener_swift(status: Bool) {
    DispatchQueue.main.async {
        vc_inst.updateAccStatus(status: status)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sipIpTField: UITextField!
    @IBOutlet weak var sipPortTField: UITextField!
    @IBOutlet weak var sipUsernameTField: UITextField!
    @IBOutlet weak var sipPasswordTField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var sipDestinationUriTField: UITextField!

    var accStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vc_inst = self
        
        // Load saved credentials and attempt to register
        loadCredentialsAndRegister()
        
        // Add done button to keyboards
        [sipIpTField, sipPortTField, sipUsernameTField, sipPasswordTField, sipDestinationUriTField].forEach { $0?.addDoneButtonOnKeyboard() }
    }
    
    func updateAccStatus(status: Bool) {
        accStatus = status
        if status 
        {
            statusLabel.text = "Reg Status: REGISTERED"
            loginButton.isEnabled = false
            logoutButton.isEnabled = true
        } 
        else
        {
            statusLabel.text = "Reg Status: NOT REGISTERED"
            loginButton.isEnabled = true
            logoutButton.isEnabled = false
        }
    }
    
    func loadCredentialsAndRegister() 
    {
        if let credentials = UserDefaults.standard.dictionary(forKey: "SIPCredentials") as? [String: String],
           let username = credentials["username"],
           let password = credentials["password"],
           let ip = credentials["ip"],
           let port = credentials["port"] {
            
            sipUsernameTField.text = username
            sipPasswordTField.text = password
            sipIpTField.text = ip
            sipPortTField.text = port
            
            CPPWrapper().createAccountWrapper(username, password, ip, port)
        }
    }
    
    func saveCredentials() 
    {
        let credentials = [
            "username": sipUsernameTField.text ?? "",
            "password": sipPasswordTField.text ?? "",
            "ip": sipIpTField.text ?? "",
            "port": sipPortTField.text ?? ""
        ]
        UserDefaults.standard.set(credentials, forKey: "SIPCredentials")
    }
    
    @IBAction func loginClick(_ sender: UIButton) {
        if !sipUsernameTField.text!.isEmpty &&
           !sipPasswordTField.text!.isEmpty &&
           !sipIpTField.text!.isEmpty &&
           !sipPortTField.text!.isEmpty {
            
            CPPWrapper().createAccountWrapper(
                sipUsernameTField.text,
                sipPasswordTField.text,
                sipIpTField.text,
                sipPortTField.text)
            
            saveCredentials()
        } 
        else {
            
            showAlert(title: "SIP SETTINGS ERROR", message: "Please fill the form")
        }
    }
    
    @IBAction func logoutClick(_ sender: UIButton)
    {
        CPPWrapper().unregisterAccountWrapper()
        UserDefaults.standard.removeObject(forKey: "SIPCredentials")
        updateAccStatus(status: false)
    }
    
    @IBAction func callClick(_ sender: UIButton) {
        if accStatus
        {
            let vcToPresent = self.storyboard!.instantiateViewController(withIdentifier: "outgoingCallVC") as! OutgoingViewController
            vcToPresent.outgoingCallId = sipDestinationUriTField.text ?? "<SIP-NUMBER>"
            self.present(vcToPresent, animated: true, completion: nil)
        } else {
            showAlert(title: "Outgoing Call Error", message: "Please register to be able to make a call")
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
