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
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //firebase authentication
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error == nil {
                //segue to main tab if sign in successful
                self.performSegue(withIdentifier: "LoginToTab", sender: self)
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        //perform segue
        performSegue(withIdentifier: "ToNewAccount", sender: self)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue, Sender: Any?) {
        //unwind to return from new account
    }

}
