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
    
    var trackList = [AlbumTrack]()
    var albumID: Int!
    var albumName: String!
    var artistName: String!
    var albumPhotoURL: String!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = artistName + " · " + albumName
        tableView.delegate = self
        tableView.dataSource = self
        self.getTracks()
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "trackTableViewCell")
        self.navigationController?.navigationBar.tintColor = UIColor.purple
        
        
    }
    
    private func getTracks(){
        APICaller.shared.getAlbumTracks(with: albumID) { data in
            switch(data){
            case .success(let track):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.trackList = track
                    self.tableView.reloadData()
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}

extension AlbumDetailViewController: UITableViewDelegate{
    
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
        if let indexPath = tableView.indexPath(for: cell) {
            let track = self.trackList[indexPath.row].preview!
            guard let url = URL(string: track) else { return }
            
            if cell.playBtn.titleLabel?.text == "Önizle" { //Play
                
                downloadFileFromURL(url: url)
            }
            else{
                cell.playBtn.titleLabel?.text == "Duraklat"
                audioPlayer.stop()

            }
            //            let playerItem = AVPlayerItem(url: url)
            //            let player = AVQueuePlayer(items: [playerItem])
            //            player.play()
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



