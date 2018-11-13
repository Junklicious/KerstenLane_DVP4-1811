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
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //instantiate new cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureViewCell
        
        //configure cell
        cell.pictureImageView.image = pictures[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BrowseToFullPicture", sender: self)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullPictureViewController {
            destination.picture = pictures[collectionView.indexPathsForSelectedItems![0].row]
        }
    }
    
    //MARK: Download JSON from Unsplash API
    
    func downloadPicturesFromUnsplash() {
        //alamofire request
        Alamofire.request("https://api.unsplash.com/photos?page=1&per_page=30&client_id=\(apiKey)").validate().responseJSON { response in
            //check if request was successful
            switch response.result {
            case .success(let value):
                
                //creat a swiftyJson object
                let json = JSON(value)
                
                //loop through resulting json
                for (_, subJson): (String, JSON) in json {
                    //create picture objects from the response and store them in pictures var
                    //guard to grab url
                    guard let url = subJson["urls"]["small"].string,
                        let urlActual = URL(string: url)
                        else{ continue }
                    
                    //grab image from url
                    var image: UIImage?
                    do {
                        let data = try Data(contentsOf: urlActual)
                        image = UIImage(data: data)
                    } catch {
                        //error
                        print(error.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        //reload collectionview to display new picture
                        self.collectionView.reloadData()
                    }
                    
                    //add new pictureObject to pictures
                    self.pictures.append(PictureObject(urls: url, image: image))
                }
                
                //print json to debug
                //print("JSON: \(json)")
            case .failure(let error):
                //print error
                print(error)
            }
        }
    }

}

