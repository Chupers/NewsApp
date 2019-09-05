//
//  CollectionViewCell.swift
//  NewsApp
//
//  Created by Eugenie Chupris on 9/1/19.
//  Copyright © 2019 Eugenie Chupris. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var NewsImage: UIImageView!
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var UIView: UIView!
    @IBOutlet weak var ShowMoreButton: UIButton!
    @IBOutlet weak var NewsTitle: UILabel!
    
    @IBOutlet weak var DescLabel: UILabel!
    override func awakeFromNib() {
        clipsToBounds = true
        layer.cornerRadius = 18
        UIView.layer.cornerRadius = 18
        NewsImage.layer.cornerRadius = 18
        NewsTitle.layer.cornerRadius = 18
        DescLabel.layer.cornerRadius = 18
        
    }
    
}
