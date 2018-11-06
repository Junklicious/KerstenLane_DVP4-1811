//
//  PictureObject.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/6/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit

class PictureObject {
    
    //MARK: Stored Properties
    
    var urls: [String]
    var image: UIImage?
    
    //MARK: Functions
    
    init() {
        urls = [String]()
    }
    
    init(urls: [String], image: UIImage?) {
        self.urls = urls
        self.image = image
    }
}
