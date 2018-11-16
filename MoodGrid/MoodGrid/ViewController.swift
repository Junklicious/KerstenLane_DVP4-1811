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
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        for i in 1...3 {
            downloadPicturesFromUnsplash(page: i)
        }
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        //signOut
        do {
            try Auth.auth().signOut()
            
            //delete user default login
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "password")
            
            performSegue(withIdentifier: "signOutUnwind", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width - 20)/3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //segue to full picture when picture is tapped in collectionView
        performSegue(withIdentifier: "BrowseToFullPicture", sender: self)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullPictureViewController {
            destination.picture = pictures[collectionView.indexPathsForSelectedItems![0].row]
        }
    }
    
    //MARK: Download JSON from Unsplash API
    
    func downloadPicturesFromUnsplash(page: Int) {
        //alamofire request
        Alamofire.request("https://api.unsplash.com/photos?page=\(page)&per_page=30&client_id=\(apiKey)").validate().responseJSON { response in
            //check if request was successful
            switch response.result {
            case .success(let value):
                
                //creat a swiftyJson object
                let json = JSON(value)
                
                //place in background thread to not lockup application
                DispatchQueue.global().async {
                    
                //loop through resulting json
                for (_, subJson): (String, JSON) in json {
                    //create picture objects from the response and store them in pictures var
                    
                        //guard to grab url
                        guard let url = subJson["urls"]["small"].string,
                            let urlActual = URL(string: url)
                            else{ return }
                        
                        //grab image from url
                        var image: UIImage?
                        do {
                            let data = try Data(contentsOf: urlActual)
                            image = UIImage(data: data)
                        } catch {
                            //error
                            print(error.localizedDescription)
                        }
                        
                        //add new pictureObject to pictures
                        self.pictures.append(PictureObject(urls: url, image: image))
                        
                        DispatchQueue.main.async {
                            //reload collectionview to display new picture
                            self.collectionView.reloadData()
                        }
                    }
                }
            case .failure(let error):
                //print error
                print(error)
            }
        }
    }

}

