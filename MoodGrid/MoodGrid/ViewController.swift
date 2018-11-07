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
    var pictures = [PictureObject]()
    let apiKey = "ac21996467c394e3c5e74768bfbb3de744913d53e81ec4ca425a7558c3ef3388"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //register xib
        collectionView.register(UINib(nibName: "PictureViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
        
        //grab pictures from API
        downloadPicturesFromUnsplash()
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
        Alamofire.request("https://api.unsplash.com/photos?page=1&client_id=\(apiKey)").validate().responseJSON { response in
            //check if request was successful
            switch response.result {
            case .success(let value):
                
                //creat a swiftyJson object
                let json = JSON(value)
                
                //loop through resulting json
                for (index, subJson): (String, JSON) in json {
                    //create picture objects from the response and store them in pictures var
                    
                    
                }
                
                //print json to debug
                print("JSON: \(json)")
            case .failure(let error):
                //print error
                print(error)
            }
        }
    }

}

