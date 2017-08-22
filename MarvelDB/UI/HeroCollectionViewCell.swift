//
//  HeroCollectionViewCell.swift
//  MarvelDB
//
//  Created by Dario Fanjul on 21/08/2017.
//  Copyright © 2017 Dario Fanjul. All rights reserved.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heroImage.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImage.layer.cornerRadius = 3
    }
}
