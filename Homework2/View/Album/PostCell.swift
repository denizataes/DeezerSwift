//
//  PostCell.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit

class PostCell: UICollectionViewCell{
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pTitle: UILabel!
    @IBOutlet weak var pReleaseDate: UILabel!

    override func awakeFromNib() {
        background.layer.cornerRadius = 12
        image.layer.cornerRadius = 12
        image.kf.indicatorType = .activity
        pTitle.adjustsFontSizeToFitWidth = true
        pTitle.sizeToFit()
    }
    

}
