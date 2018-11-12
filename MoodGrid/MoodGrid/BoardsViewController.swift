//
//  BoardsViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/1/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class BoardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    var boards = [String: [PictureObject]]()
    var ref: DatabaseReference!
    var okAlert: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set referenct to database
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //pull boards from firebase
        self.ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let dict = (child as! DataSnapshot).value as! NSDictionary
                let boardName = dict["name"] as! String
                var pictureArray = [PictureObject]()
                if let pictures = dict["pictures"] {
                    for item in Array((pictures as! NSDictionary).allValues) {
                        let pictureUrl = item as! String
                        pictureArray.append(PictureObject(urls: pictureUrl, image: nil))
                    }
                }
                //set values to boards
                self.boards[boardName] = pictureArray
                DispatchQueue.main.async {
                    //reload table view
                    self.tableView.reloadData()
                }
            }
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        //create alert for adding a new board
        let alert = UIAlertController(title: "Add New Board", message: "Enter the name of the new board.", preferredStyle: .alert)
        
        //cancel button
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .destructive, handler: nil ))
        
        //ok button
        okAlert = UIAlertAction(title: NSLocalizedString("Add", comment: "Add action"), style: .default, handler: { (alertAction) in
            //add new empty board to boards with name from text field
            self.boards[alert.textFields![0].text!] = [PictureObject]()
            
            //add new board to firebase database under the users ID
            self.ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").childByAutoId().child("name").setValue(alert.textFields![0].text!)
            
            //test
            self.ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").observeSingleEvent(of: .value, with: { (snapshot) in
                for child in snapshot.children {
                    let dict = (child as! DataSnapshot).value as! NSDictionary
                    print(dict["name"] as! String)
                }
            }, withCancel: { (error) in
                print(error.localizedDescription)
            })
            
            //reload tableView
            self.tableView.reloadData()
        })
        alert.addAction(okAlert)
        
        //add text field to alert
        alert.addTextField { (textField) in
            //setup textField
            textField.placeholder = "New Board Name"
            //disable okAlert
            self.okAlert.isEnabled = false
            //add a function to trigger when text is changed
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        //TODO: Add edit functionality
    }
    
    @objc func alertTextFieldDidChange(_ textField: UITextField) {
        //activate okAlert when text is entered
        if textField.text != "" {
            //ensure entered text is not a duplicate of an already existing mood board
            for name in Array(boards.keys) {
                if textField.text?.lowercased() == name.lowercased() {
                    okAlert.isEnabled = false
                    return
                }
            }
            okAlert.isEnabled = true
        } else {
            okAlert.isEnabled = false
        }
    }
    
    //MARK: TableViewDataSource Callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //instantiate tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! BoardTableViewCell
        
        //configure cell
        cell.boardName.text = Array(boards.keys)[indexPath.row]
        
        return cell
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
