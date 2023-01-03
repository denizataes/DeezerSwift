//
//  ViewController.swift
//  Homework2
//
//  Created by Deniz Ata Eş on 29.12.2022.
//

import UIKit
import Kingfisher
class HomeViewController: UIViewController {

    var genres = [Genre]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    ///Configure navigation, tableview, and others...
    private func configure(){
        // MARK: TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "homeTableViewCell")
        
        // MARK: NavigationController
        navigationController?.navigationBar.tintColor = UIColor.purple
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "Kategoriler ⚡️"
        
        getGenres()
    }
    
    ///Get Genres and reload tableview
    private func getGenres(){
        APICaller.shared.getGenres { data in
            switch(data)
            {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genres = genres.data ?? [Genre]()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



//MARK: TableView Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell

        cell.label.text = self.genres[indexPath.row].name
        cell.photoView.image = UIImage(named: self.genres[indexPath.row].picture_medium ?? "")
        
        cell.photoView.kf.setImage(with: URL(string: "\(self.genres[indexPath.row].picture_xl ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc =  storyboard?.instantiateViewController(withIdentifier: "genreViewController") as? GenreViewController{
            let genre = genres[indexPath.row]
            vc.genreID = genre.id!
            vc.genreName = genre.name!
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}

