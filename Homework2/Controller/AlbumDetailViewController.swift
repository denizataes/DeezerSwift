//
//  AlbumDetailViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit
import MediaPlayer

class AlbumDetailViewController: UIViewController, AVAudioPlayerDelegate {
    var audioPlayer:AVAudioPlayer!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var trackList = [AlbumTrack]()
    var albumID: Int!
    var albumName: String!
    var artistName: String!
    var albumPhotoURL: String!
    

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = artistName
        tableView.delegate = self
        tableView.dataSource = self
        activityIndicator.startAnimating()
        self.getTracks()
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "trackTableViewCell")
        self.navigationController?.navigationBar.tintColor = UIColor.purple
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        navigationController?.navigationBar.prefersLargeTitles = false
        setMultilineNavigationBar(topText: albumName, bottomText: artistName)
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        if audioPlayer != nil{
            audioPlayer.stop()
        }
    }
    
    private func getTracks(){
        APICaller.shared.getAlbumTracks(with: albumID) { data in
            switch(data){
            case .success(let track):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.trackList = track
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setMultilineNavigationBar(topText:  String, bottomText : String) {
         let topTxt = NSLocalizedString(topText, comment: "")
         let bottomTxt = NSLocalizedString(bottomText, comment: "")
            
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                   NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor.systemGray4,
                                      NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13, weight: .semibold)]
            
         let title:NSMutableAttributedString = NSMutableAttributedString(string: topTxt, attributes: titleParameters)
         let subtitle:NSAttributedString = NSAttributedString(string: bottomTxt, attributes: subtitleParameters)
            
         title.append(NSAttributedString(string: "\n"))
         title.append(subtitle)
            
         let size = title.size()
            
         let width = size.width
         guard let height = navigationController?.navigationBar.frame.size.height else {return}
            
          let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
          titleLabel.attributedText = title
          titleLabel.numberOfLines = 0
          titleLabel.textAlignment = .center
          self.navigationItem.titleView = titleLabel
        }
}

extension AlbumDetailViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
        cell.delegate = self
        let track = self.trackList[indexPath.row]
        cell.trackTitleLabel.text = track.title
        let seconds = track.duration!
        let minutes = seconds / 60
        cell.durationLabel.text = "\(minutes) dakika \(seconds % 60) saniye"
        cell.albumImageView.kf.setImage(with: URL(string: "\( self.albumPhotoURL ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        cell.trackArtistLabel.text = self.artistName
        cell.trackTitleLabel.text = track.title
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trackList.count
    }
    
    
}

extension AlbumDetailViewController: MyCellDelegate{
    func didTapButtonInCell(_ cell: TrackTableViewCell) {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) {
            if i != tableView.indexPath(for: cell)?.row{
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TrackTableViewCell
                //let button = cell.viewWithTag(1) as? UIButton
                let btn = cell?.playBtn
                btn?.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
        
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
    
        if let indexPath = tableView.indexPath(for: cell) {
            let track = self.trackList[indexPath.row].preview!
            guard let url = URL(string: track) else { return }
            
            if cell.playBtn.image(for: .normal) == UIImage(systemName: "play") {
                downloadFileFromURL(url: url)
            }
            else{
                if audioPlayer != nil && audioPlayer.isPlaying{
                    audioPlayer.stop()
                }
            }
        }
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    
    func play(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}

