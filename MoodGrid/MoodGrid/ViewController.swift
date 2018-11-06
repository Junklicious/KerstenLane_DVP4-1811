//
//  ViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 10/30/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //variables
    var pictures = [String]()
    let apiKey = "ac21996467c394e3c5e74768bfbb3de744913d53e81ec4ca425a7558c3ef3388"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView.register(UINib(nibName: "PictureViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
    }

    //MARK: CollectionView Callbacks
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //instantiate new cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureViewCell
        
        //configure cell
        cell.pictureImageView.backgroundColor = UIColor.blue
        
        return cell
    }
    
    //MARK: Download JSON from Unsplash API
    
    func downloadPicturesFromUnsplash() {
        //alamofire request
        Alamofire.request("https://api.unsplash.com/photos?page=1&client_id=\(apiKey)").responseJSON { (response) in
            print(response)
            
            if let jsonObj = response.result.value {
                let json = JSON(jsonObj)
            }
        }
    }

}

