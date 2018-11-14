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
