//
//  ViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 10/30/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //variables
    var pictures = [String]()

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

}

