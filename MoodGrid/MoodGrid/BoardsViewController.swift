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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set referenct to database
        ref = Database.database().reference()
        
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        //create alert for adding a new board
        let alert = UIAlertController(title: "Add New Board", message: "Enter the name of the new board.", preferredStyle: .alert)
        
        //add text field to alert
        alert.addTextField { (textField) in
            textField.placeholder = "New Board Name"
        }
        
        //ok button
        alert.addAction(UIAlertAction(title: NSLocalizedString("Add", comment: "Add action"), style: .default, handler: { (alertAction) in
            //add new empty board to boards with name from text field
            self.boards[alert.textFields![0].text!] = [PictureObject]()
        }))
        
        //cancel button
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .destructive, handler: nil ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        
    }
    
    //MARK: TableViewDataSource Callbacks
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //instantiate tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! BoardTableViewCell
        
        //configure cell
        
        
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
