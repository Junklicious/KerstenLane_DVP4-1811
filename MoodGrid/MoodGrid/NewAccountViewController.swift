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
        //blank validation
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || reTypeTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Empty Input Fields!", message: "Please fill in all text fields before you continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            //return from function
            return
        }
        
        //password validation
        if passwordTextField.text! != reTypeTextField.text! {
            let alert = UIAlertController(title: "Passwords Do Not Match", message: "Please ensure you password matches the re-typed password.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
            //return from function
            return
        }
        
        //email validation
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
            let results = regex.matches(in: usernameTextField.text!, range: NSRange(location: 0, length: usernameTextField.text!.count))
            
            if results.count == 0 {
                let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid email address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
                self.present(alert, animated: true, completion: nil)
                //return from function
                return
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        //create new account in firebase if user doesn't already exist
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (result, error) in
            //segue to main tab if account creation is successful
            if error == nil {
                self.performSegue(withIdentifier: "NewAccountToTab", sender: self)
            } else {
                let alert = UIAlertController(title: "Acount Already Exists", message: "An account with those credentials already exists.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard on touchEnd
        self.view.endEditing(true)
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
