//
//  AlbumSearchTableViewCell.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 1.01.2023.
//

import UIKit
import Kingfisher

class AlbumSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistTitleLabel: UILabel!
    @IBOutlet weak var artistImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImage.kf.indicatorType = .activity
        artistImage.kf.indicatorType = .activity
        artistImage.layer.cornerRadius = artistImage.frame.width / 2
        artistImage.clipsToBounds = true
        albumImage.layer.cornerRadius = 15
        albumImage.layer.shadowRadius = 10
        albumTitleLabel.adjustsFontSizeToFitWidth = true
        albumTitleLabel.sizeToFit()
     
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
