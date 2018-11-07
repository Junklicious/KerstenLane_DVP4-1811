//
//  BoardTableViewCell.swift
//  MoodGrid
//
//  Created by Lane Kersten on 11/6/18.
//  Copyright © 2018 Lane Kersten. All rights reserved.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    //outlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var boardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
