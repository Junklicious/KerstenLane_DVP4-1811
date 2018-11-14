//
//  FullPictureViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/12/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit

class FullPictureViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    //variables
    var picture: PictureObject!
    var trashEnabled = false
    var boardName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //display picture in imageView
        imageView.image = picture.image
        
        if !trashEnabled {
            trashButton.tintColor = UIColor.clear
            trashButton.isEnabled = false
        }
    }
    
    @IBAction func xTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func trashTapped(_ sender: UIBarButtonItem) {
        //create alert to show the user to confirm delete
        let alert = UIAlertController(title: "Delete Picture", message: "Are you sure you want to delete this picture from '\(boardName!)'?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete action"), style: .destructive, handler: { _ in
            
            //unwind to selected
            self.performSegue(withIdentifier: "unwindToSelected", sender: self)
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check destination is AddPictureViewController
        if let destination = segue.destination as? AddPictureViewController {
            //send picture to AddPictureViewController
            destination.picture = picture
        }
        
        //if destination is selected board then pass picture info
        if let destination = segue.destination as? SelectedBoardViewController {
            destination.pictureToBeDeleted = picture.key
        }
    }
}
