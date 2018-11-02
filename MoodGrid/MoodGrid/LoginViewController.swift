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
            
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        //perform segue
        performSegue(withIdentifier: "ToNewAccount", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
