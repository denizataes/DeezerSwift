//
//  SearchViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit
import Kingfisher
import MediaPlayer

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    //MARK: Defining Properties
    @IBOutlet weak var tableView: UITableView!
    var artistSearchList = [SearchArtist]()
    var albumSearchList = [SearchAlbum]()
    var trackSearchList = [SearchTrack]()
    let searchController = UISearchController()
    let sections: [String] = Category.allCases.map { $0.buttonTitle }
    var audioPlayer:AVAudioPlayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    ///Configure navigation, tableview, and others...
    private func configure(){
        
        //MARK: NavigationController
        navigationController?.navigationBar.topItem?.title = "Ara 👀"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = false
        definesPresentationContext = true



        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: SearchController
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.scopeButtonTitles = sections
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("İptal", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Albüm, şarkı veya sanatçı ara..."

        
        //MARK: Register cell
        tableView.register(UINib(nibName: "AlbumSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "albumSearchTableViewCell")
        tableView.register(UINib(nibName: "TrackSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "trackSearchTableViewCell")
        tableView.register(UINib(nibName: "TrackTableViewCell", bundle: nil), forCellReuseIdentifier: "trackTableViewCell")
        tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "artistTableViewCell")
        
    }
    
    private func searchByQuery(type: String, query: String){
        
        switch(type)
        {
        case Category.artist.buttonTitle:
            APICaller.shared.searchArtistByQuery(query: query) { data in
                switch(data)
                {
                case .success(let searchList):
                    DispatchQueue.main.async {
                        self.artistSearchList = searchList.data ?? [SearchArtist]()
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Category.album.buttonTitle:
            APICaller.shared.searchAlbumByQuery(query: query) { data in
                switch(data)
                {
                case .success(let searchList):
                    DispatchQueue.main.async {
                        self.albumSearchList = searchList.data ?? [SearchAlbum]()
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Category.track.buttonTitle:
            APICaller.shared.searchTrackByQuery(query: query) { data in
                switch(data)
                {
                case .success(let searchList):
                    DispatchQueue.main.async {
                        self.trackSearchList = searchList.data ?? [SearchTrack]()
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            print("")
        }
    }
    
    ///first download mp3 file then play it. if there is an already playing music, stop it.
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
    
    
    ///If searchController change this method will be trigger.
    func updateSearchResults(for searchController: UISearchController) {
        if audioPlayer != nil && audioPlayer.isPlaying{
            audioPlayer.stop()
        }
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        searchByQuery(type: scopeButton, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
    }}

//MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate{
    ///If searchController textfield change then search by query.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        switch(scopeButton)
        {
        case Category.artist.buttonTitle:
            searchByQuery(type: Category.artist.rawValue, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        case Category.album.buttonTitle:
            searchByQuery(type: Category.album.rawValue, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        case Category.track.buttonTitle:
            searchByQuery(type: Category.track.rawValue, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        default:
            print("")
        }
        
    }
}

extension SearchViewController: UITableViewDelegate{
    ///If row selected then look scopeButton and navigate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        switch(scopeButton)
        {
        case Category.album.buttonTitle: ///if scope == album then navigate to AlbumDetailViewController
            if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumDetailViewController") as? AlbumDetailViewController{
                let album = albumSearchList[indexPath.row]
                vc.albumID = album.id
                vc.albumName = album.title
                vc.artistName = album.artist?.name
                vc.albumPhotoURL = album.cover_xl
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case Category.track.buttonTitle: ///if scope == track do nothing
            print("")
        case Category.artist.buttonTitle: ///if scope == artist then navigate to AlbumViewController
            if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumViewController") as? AlbumViewController{
                let artist = self.artistSearchList[indexPath.row]
                vc.artistID = artist.id
                vc.artistName = artist.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            print("") /// do nothing
        }
        
    }
}

extension SearchViewController: UITableViewDataSource{
    ///the number of cells changes according to the selected scope
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        switch(scopeButton)
        {
        case Category.album.buttonTitle:
            return self.albumSearchList.count
        case Category.track.buttonTitle:
            return self.trackSearchList.count
            
        case Category.artist.buttonTitle:
            return self.artistSearchList.count
        default:
            return 0
        }
    }
    ///cell types change according to the selected scope
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        switch(scopeButton)
        {
        case Category.album.buttonTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumSearchTableViewCell", for: indexPath) as! AlbumSearchTableViewCell
    
            let album = albumSearchList[indexPath.row]
            if album.artist != nil{
                cell.artistTitleLabel.text = album.artist?.name
            }
            else{
                cell.artistTitleLabel.text = ""
            }
            cell.albumTitleLabel.text = album.title
            
            cell.artistImage.kf.setImage(with: URL(string: "\(album.artist?.picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            cell.albumImage.kf.setImage(with: URL(string: "\(album.cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            return cell
        case Category.track.buttonTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "trackTableViewCell", for: indexPath) as! TrackTableViewCell
            cell.delegate = self
            let track = self.trackSearchList[indexPath.row]
            cell.trackTitleLabel.text = track.title
            let seconds = track.duration!
            let minutes = seconds / 60
            cell.durationLabel.text = "\(minutes) dakika \(seconds % 60) saniye"
            cell.albumImageView.kf.setImage(with: URL(string: "\( track.album?.cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            cell.trackArtistLabel.text = track.artist?.name
            cell.trackTitleLabel.text = track.title
            return cell
        case Category.artist.buttonTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell
            cell.label.text = String(self.artistSearchList[indexPath.row].name ?? "")
            cell.photoView.kf.setImage(with: URL(string: "\(self.artistSearchList[indexPath.row].picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            return cell
        default:
           return UITableViewCell()
        }
    }
}
extension SearchViewController: TrackCellDelegate{
    func didTapButtonInCell(_ cell: TrackTableViewCell) {
        
        for i in 0..<tableView.numberOfRows(inSection: 0) { ///Set button images of all cells to "play" except the selected cell
            if i != tableView.indexPath(for: cell)?.row {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TrackTableViewCell
                let btn = cell?.playBtn
                btn?.setImage(UIImage(systemName: "play"), for: .normal)
            }
        }
        
        if audioPlayer != nil && audioPlayer.isPlaying{ /// If music is playing stop it
            audioPlayer.stop()
        }
    
        if let indexPath = tableView.indexPath(for: cell) {
            let track = self.trackSearchList[indexPath.row].preview!
            guard let url = URL(string: track) else { return } ///check if url exists
            
            if cell.playBtn.image(for: .normal) == UIImage(systemName: "play") {
                downloadFileFromURL(url: url) /// First download the mp3 file then play it
            }
            else{
                if audioPlayer != nil && audioPlayer.isPlaying{
                    audioPlayer.stop()
                }
            }
        }
    }

}
