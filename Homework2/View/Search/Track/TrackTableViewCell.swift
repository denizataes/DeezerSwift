//
//  TrackTableViewCell.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 2.01.2023.
//

import UIKit
import Kingfisher
protocol MyCellDelegate{
      func didTapButtonInCell(_ cell: TrackTableViewCell)
    
}

class TrackTableViewCell: UITableViewCell {
    var delegate: MyCellDelegate?

    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackArtistLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        albumImageView.kf.indicatorType = .activity
        albumImageView.layer.cornerRadius = 20
        playBtn.setImage(UIImage(systemName: "play"), for: .normal)
        playBtn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        trackTitleLabel.adjustsFontSizeToFitWidth = true
        trackTitleLabel.sizeToFit()
        trackArtistLabel.adjustsFontSizeToFitWidth = true
        trackArtistLabel.sizeToFit()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

    @IBAction func btnClicked(_ sender: Any) {
        delegate?.didTapButtonInCell(self)
    }
    
    @objc func playButtonTapped() {
         if playBtn.image(for: .normal) == UIImage(systemName: "play") {
             playBtn.setImage(UIImage(systemName: "pause"), for: .normal)
         } else {
             playBtn.setImage(UIImage(systemName: "play"), for: .normal)
         }
     }

}
