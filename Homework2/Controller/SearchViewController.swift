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
    var searchList = [Search]()
    let searchController = UISearchController()
    let sections = ["artist", "album", "track"]
    //var filteredShapes = []()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Ara 👀"
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        APICaller.shared.searchByQuery(type: type, query: query) { data in
            switch(data)
            {
            case .success(let searchList):
                DispatchQueue.main.async {
                    self.searchList = searchList.data ?? [Search]()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
//        guard searchText.count > 3 else {return} // after 3 letters, search
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        searchByQuery(type: scopeButton, query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        
        //aprint(searchText)
    }
}

extension SearchViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        if(scopeButton == "artist"){
            if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumViewController") as? AlbumViewController{
                let artist = self.searchList[indexPath.row]
                vc.artistID = artist.id
                vc.artistName = artist.name
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
}

extension SearchViewController: UITableViewDataSource{
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]

        switch(scopeButton)
        {
        case "album":
            cell.label.text = self.searchList[indexPath.row].title
            cell.photoView.kf.setImage(with: URL(string: "\(self.searchList[indexPath.row].cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        case "track":
            
            cell.label.text = self.searchList[indexPath.row].title
            cell.photoView.kf.setImage(with: URL(string: "\(self.searchList[indexPath.row].cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
            
        case "artist":
            cell.label.text = String(self.searchList[indexPath.row].name ?? "")
            cell.photoView.kf.setImage(with: URL(string: "\(self.searchList[indexPath.row].picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        default:
            return cell
        }
        

        return cell
    }

    
}
