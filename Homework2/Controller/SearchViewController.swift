//
//  SearchViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
    
    @IBOutlet weak var tableView: UITableView!
    var artistSearchList = [SearchArtist]()
    var albumSearchList = [SearchAlbum]()
    var trackSearchList = [SearchTrack]()
    let searchController = UISearchController()
    let sections: [String] = Category.allCases.map { $0.buttonTitle }
    
    
    //    let sections = ["artist", "album", "track"]
    //var filteredShapes = []()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Ara 👀"
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UINib(nibName: "AlbumSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "albumSearchTableViewCell")

        tableView.register(UINib(nibName: "TrackSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "trackSearchTableViewCell")

        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = sections
        searchController.searchBar.delegate = self
        
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
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        searchByQuery(type: scopeButton, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
    }}

//MARK: SearchBar Delegate
extension SearchViewController: UISearchBarDelegate{
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        switch(scopeButton)
        {
        case Category.album.buttonTitle:
            print("")
        case Category.track.buttonTitle:
            
            print("")
            
        case Category.artist.buttonTitle:
            if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumViewController") as? AlbumViewController{
                let artist = self.artistSearchList[indexPath.row]
                vc.artistID = artist.id
                vc.artistName = artist.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            print("")
        }
        
    }
}

extension SearchViewController: UITableViewDataSource{
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "trackSearchTableViewCell", for: indexPath) as! TrackSearchTableViewCell
            let track = self.trackSearchList[indexPath.row]
            cell.trackTitleLabel.text = track.title
            cell.durationLabel.text = String(track.duration ?? 0) + " Saniye"
            cell.trackImage.kf.setImage(with: URL(string: "\(track.album?.cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            cell.artistImage.kf.setImage(with: URL(string: "\(track.artist?.picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            cell.artistTitleLabel.text = track.artist?.name
            return cell
            
        case Category.artist.buttonTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell
            cell.label.text = String(self.artistSearchList[indexPath.row].name ?? "")
            cell.photoView.kf.setImage(with: URL(string: "\(self.artistSearchList[indexPath.row].picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell
            return cell
        }
        
        
 
    }
    
    
}
