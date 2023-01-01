//
//  TrackSearchTableViewCell.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 1.01.2023.
//
import Kingfisher
import UIKit

class TrackSearchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImage.kf.indicatorType = .activity
        artistImage.kf.indicatorType = .activity
        artistImage.layer.cornerRadius = artistImage.frame.width/2
        artistImage.clipsToBounds = true
        trackImage.layer.cornerRadius = 15
        trackImage.layer.shadowRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
