//
//  GenreViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit

class GenreViewController: UIViewController {
    var genreID: Int!
    var genreName: String!
    var artistList = [GenreArtist]()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = genreName
        self.navigationController?.navigationBar.tintColor = UIColor.purple
        activityIndicator.startAnimating()
        activityIndicator.style = .medium
        tableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "artistTableViewCell")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getArtist()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }

    private func getArtist(){
        
        APICaller.shared.getGenreArtist(with: genreID) { data in
            switch(data)
            {
            case .success(let artist):
                DispatchQueue.main.async{
                    self.artistList = artist.data ?? [GenreArtist]()
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
//MARK: TableView Delegate
extension GenreViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumViewController") as? AlbumViewController{
            let artist = artistList[indexPath.row]
            vc.artistID = artist.id
            vc.artistName = artist.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: TableView Datasource
extension GenreViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistTableViewCell", for: indexPath) as! ArtistTableViewCell

        cell.label.text = self.artistList[indexPath.row].name
        cell.photoView.kf.setImage(with: URL(string: "\(self.artistList[indexPath.row].picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistList.count
    }
    
}
