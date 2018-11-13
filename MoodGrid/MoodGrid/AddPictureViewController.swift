//
//  AddPictureViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/12/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddPictureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outlets
    @IBOutlet weak var tableView: UITableView!
    
    //variables
    var picture: PictureObject!
    var boards = [String: String]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set referenct to database
        ref = Database.database().reference()
        
        //pull boards to show user which boards they can add to
        pullBoards()
        
        tableView.isEditing = true
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITableViewDataSource Callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardAddCell", for: indexPath)
        
        //configure cell
        cell.textLabel?.text = Array(boards.keys)[indexPath.row]
        
        return cell
    }
    
    //MARK: Database connection
    
    func pullBoards() {
        //pull boards from firebase
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let dict = (child as! DataSnapshot).value as! NSDictionary
                let boardName = dict["name"] as! String
                let key = (child as! DataSnapshot).key
                //set values to boards
                self.boards[boardName] = key
                DispatchQueue.main.async {
                    //reload table view
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func doneTapped() {
        //add picture to selected databases
        if let indexPaths = tableView.indexPathsForSelectedRows {
            for index in indexPaths {
                let name = Array(boards.keys)[index.row]
                ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").child(boards[name]!).child("pictures").childByAutoId().setValue(picture.urls)
            }
            //return to fullpicture view
            dismiss(animated: true, completion: nil)
        } else {
            //no selection error
            let alert = UIAlertController(title: "No Boards selected!", message: "Please select one or more boards to add the picture to.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil ))
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
