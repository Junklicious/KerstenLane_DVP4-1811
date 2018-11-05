//
//  NewAccountViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/1/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Firebase

class NewAccountViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        //create new account in firebase if user doesn't already exist
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (result, error) in
            //segue to main tab if account creation is successful
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "NewAccountToTab", sender: self)
            }
        }
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
