//
//  SearchViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/1/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Variables
    var pictures = [PictureObject]()
    let apiKey = "ac21996467c394e3c5e74768bfbb3de744913d53e81ec4ca425a7558c3ef3388"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //register xib
        collectionView.register(UINib(nibName: "PictureViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
        
        //hide collectionView to show empty state
        collectionView.isHidden = true
    }
    
    //MARK: CollectionViewDataSource Callbacks
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //check if there are results and display empty state if not
        if pictures.count != 0 {
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
        
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
    
    //MARK: SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        pictures = [PictureObject]()
        if searchBar.text != "" {
            downloadPicturesFromUnsplash(searchBar.text!)
        }
    }
    
    //MARK: API
    
    func downloadPicturesFromUnsplash(_ query: String) {
        //alamofire request
        Alamofire.request("https://api.unsplash.com/search/photos?page=1&per_page=30&client_id=\(apiKey)&query=\(query)").validate().responseJSON { response in
            //check if request was successful
            switch response.result {
            case .success(let value):
                
                //creat a swiftyJson object
                let json = JSON(value)
                
                //loop through resulting json
                for (_, subJson): (String, JSON) in json["results"] {
                    //create picture objects from the response and store them in pictures var
                    //place in background thread to not lockup application
                    DispatchQueue.global().async {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
