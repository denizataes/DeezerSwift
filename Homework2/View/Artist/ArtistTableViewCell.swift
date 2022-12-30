//
//  ArtistTableViewCell.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit
import Kingfisher

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurePhotoView()
        photoView.kf.indicatorType = .activity

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func configurePhotoView(){
        photoView.layer.cornerRadius = photoView.frame.height/2
        photoView.clipsToBounds = true
        
        
    }
    
}
