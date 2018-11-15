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
    var boardIDs = [String: String]()
    var ref: DatabaseReference!
    var okAlert: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set referenct to database
        ref = Database.database().reference()
        
        //pull data from database
        pullBoards()
    }
    
    func pullBoards() {
        //pull boards from firebase
        ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").observe(.value) { (snapshot) in
            //clear current data
            self.boards = [String: [PictureObject]]()
            
            for child in snapshot.children {
                let dict = (child as! DataSnapshot).value as! NSDictionary
                let boardName = dict["name"] as! String
                self.boardIDs[boardName] = (child as! DataSnapshot).key
                var pictureArray = [PictureObject]()
                if let pictures = dict["pictures"] {
                    for (key, item) in zip(Array((pictures as! NSDictionary).allKeys), Array((pictures as! NSDictionary).allValues)) {
                        let pictureUrl = item as! String
                        let pictureObj = PictureObject(urls: pictureUrl, image: nil)
                        pictureObj.key = key as? String
                        pictureArray.append(pictureObj)
                    }
                }
                //set values to boards
                self.boards[boardName] = pictureArray
                DispatchQueue.main.async {
                    //reload table view
                    self.tableView.reloadData()
                }
                //fetch pictures in background thread
                DispatchQueue.global().async {
                    guard self.boards[boardName]?.count != 0,
                        let stringUrl = self.boards[boardName]?[0].urls
                        else { return }
                        let image = self.getPictureFromUrl(stringUrl)
                        self.boards[boardName]?[0].image = image
                        //update UI in main thread
                        DispatchQueue.main.async {
                            //reload table view
                            self.tableView.reloadData()
                        }
                }
            }
        }
    }
    
    func getPictureFromUrl(_ urlString: String) -> UIImage? {
        //optional binding to convert string to url
        if let urlActual = URL(string: urlString) {
            //grab image from url
            var image: UIImage?
            do {
                let data = try Data(contentsOf: urlActual)
                image = UIImage(data: data)
                return image
            } catch {
                //error
                print(error.localizedDescription)
            }
        }
        //return nil if no image could be retrieved
        return nil
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
        //change editing
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                               target: self,
                                                               action: #selector (BoardsViewController.trashAllSelected))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                target: self,
                                                                action: #selector (BoardsViewController.addTapped(_:)))
        }
    }
    
    @objc func trashAllSelected() {
        //create alert to show the user to confirm delete
        let alert = UIAlertController(title: "Delete Items", message: "Are you sure you want to delete these items?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete action"), style: .destructive, handler: { _ in
            //trash all the selected items
            if var selectedIPs = self.tableView.indexPathsForSelectedRows {
                
                //sort in largest to smallest index as to remove from back to front
                selectedIPs.sort { (a, b) -> Bool in
                    a.row > b.row
                }
                
                for indexPath in selectedIPs {
                    //update the data
                    let nameToDelete = Array(self.boards.keys)[indexPath.row]
                    self.ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").child(self.boardIDs[nameToDelete]!).removeValue()
                    self.boards.removeValue(forKey: nameToDelete)
                }
                
                //delete all the rows at one
                self.tableView.deleteRows(at: selectedIPs, with: .left)
                //reload data to update header
                self.tableView.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        if Array(boards.values)[indexPath.row].count != 0 {
            if let image = Array(boards.values)[indexPath.row][0].image {
                cell.backgroundImage.image = image
            } else {
                cell.backgroundImage.image = nil
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //optional bind destination
        if let destination = segue.destination as? SelectedBoardViewController {
            //send necessary info to selectedBoard View
            let boardName = Array(boards.keys)[tableView.indexPathsForSelectedRows![0].row]
            destination.boardName = boardName
            destination.boardID = boardIDs[boardName]
            destination.pictures = boards[boardName]!
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if tableView.isEditing {
            return false
        } else {
            return true
        }
    }
}
