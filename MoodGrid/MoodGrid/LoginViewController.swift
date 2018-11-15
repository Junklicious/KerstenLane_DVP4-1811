//
//  LoginViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/1/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //immediately login if userdefaults for it exist
        loginFromDefaults()
    }
    
    func loginFromDefaults() {
        guard let username = UserDefaults.standard.value(forKey: "username") as? String,
            let password = UserDefaults.standard.value(forKey: "password") as? String
            else { return }
        
        //firebase authentication
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            if error == nil {
                //segue to main tab if sign in successful
                self.performSegue(withIdentifier: "AutoLogin", sender: self)
            }
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //firebase authentication
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error == nil {
                //save user info to UserDefaults
                UserDefaults.standard.setValue(self.usernameTextField.text!, forKey: "username")
                UserDefaults.standard.setValue(self.passwordTextField.text!, forKey: "password")
                
                //segue to main tab if sign in successful
                self.performSegue(withIdentifier: "LoginToTab", sender: self)
            } else {
                //error message
                let alert = UIAlertController(title: "Invalid Login", message: "An account with that email and password does not exist", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        //perform segue
        performSegue(withIdentifier: "ToNewAccount", sender: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard on touchEnd
        self.view.endEditing(true)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue, Sender: Any?) {
        //unwind to return from new account
    }

}
