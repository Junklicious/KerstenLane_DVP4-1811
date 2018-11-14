//
//  SelectedBoardViewController.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/1/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectedBoardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //variables
    var boardName: String!
    var boardID: String!
    var pictures = [PictureObject]()
    var ref: DatabaseReference!
    var pictureToBeDeleted: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //register xib
        collectionView.register(UINib(nibName: "PictureViewCell", bundle: nil), forCellWithReuseIdentifier: "PictureCell")
        
        //make the board name the navigation bar title
        navItem.title = boardName
        
        //set database reference
        ref = Database.database().reference()
        
        //load in pictures
        for picture in pictures {
            if picture.image == nil {
                DispatchQueue.global().async {
                    picture.image = self.getPictureFromUrl(picture.urls)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func getPictureFromUrl(_ urlString: String) -> UIImage? {
        //optional binding to convert string to url
        if let urlActual = URL(string: urlString) {
            //grab image from url
            var image: UIImage?
            do {
                let data = try Data(contentsOf: urlActual)
                image = UIImage(data: data)
                return image
            } catch {
                //error
                print(error.localizedDescription)
            }
        }
        //return nil if no image could be retrieved
        return nil
    }
    
    func deletePicture() {
        //delete picture from firebase
        self.ref.child("users").child(Auth.auth().currentUser!.uid).child("boards").child(self.boardID).child("pictures").child(self.pictureToBeDeleted).removeValue()
        
        for (index, pic) in self.pictures.enumerated() {
            if pic.key == self.pictureToBeDeleted {
                self.pictures.remove(at: index)
            }
        }
        
        //update collection view
        self.collectionView.reloadData()
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        
    }
    
    //MARK: CollectionViewDataSource Callbacks
    
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
        performSegue(withIdentifier: "SelectedToFullPicture", sender: self)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullPictureViewController {
            destination.picture = pictures[collectionView.indexPathsForSelectedItems![0].row]
            destination.trashEnabled = true
            destination.boardName = boardName
        }
    }
    
    @IBAction func unwindToSelectedBoard(_ segue: UIStoryboardSegue, sender: Any?) {
        //unwind called when delete button is tapped on FullPictureViewController
        deletePicture()
    }
}
