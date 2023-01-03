//
//  AlbumViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 30.12.2022.
//

import UIKit
import Kingfisher

class AlbumViewController: UIViewController {
    var artistID: Int!
    var artistName: String!
    var artistAlbums = [ArtistAlbum]()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    ///Configure navigation, tableview, and others...
    private func configure(){
        // MARK: CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // MARK: NavigationController
        navigationController?.navigationBar.tintColor = UIColor.purple
        title = artistName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.getArtistAlbums()
        }
    }

    private func getArtistAlbums(){

        APICaller.shared.getArtistAlbums(with: artistID) { data in
            switch(data)
            {
            case .success(let album):
                DispatchQueue.main.async{
                    self.artistAlbums = album.data ?? [ArtistAlbum]()
                    self.collectionView.reloadData()
                   // self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    
   
    }

}

extension AlbumViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "albumDetailViewController") as? AlbumDetailViewController{
            let album = artistAlbums[indexPath.row]
            vc.albumID = album.id
            vc.albumName = album.title
            vc.artistName = self.artistName
            vc.albumPhotoURL = album.cover_xl
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension AlbumViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artistAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostCell
        let album = artistAlbums[indexPath.row]
        cell.image.kf.setImage(with: URL(string: "\(album.cover_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        cell.pTitle.text = album.title ?? ""
        var releaseDate = ""
        if album.release_date != nil{
            releaseDate = Utils.shared.convertDate(dateString: album.release_date!)
        }
            
        cell.pReleaseDate.text = "'\(releaseDate)"
        return cell
    }
    
    
}



