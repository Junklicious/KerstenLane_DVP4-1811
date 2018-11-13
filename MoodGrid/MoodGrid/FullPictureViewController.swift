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
    
    //variables
    var picture: PictureObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //display picture in imageView
        imageView.image = picture.image
    }
    
    @IBAction func xTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
