import Foundation

struct Constants{
    static let baseURL = "https://api.deezer.com"
}

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    //MARK: Get Query
    func getGenres(completion: @escaping (Result<Genres, Error>) -> Void){

        guard let url = URL(string: "\(Constants.baseURL)/genre") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(Genres.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    func getAlbum(with id: Int, completion: @escaping (Result<Album, Error>) -> Void){

        guard let url = URL(string: "\(Constants.baseURL)/album/\(id)") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(Album.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    func getAlbumTracks(with id: Int, completion: @escaping (Result<[AlbumTrack], Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/album/\(id)/tracks") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(AlbumTracks.self, from: data)
                results.data?.forEach({ item in
                    print(item.title)
                })
                completion(.success(results.data ?? [AlbumTrack]()))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    func getArtist(with id: Int, completion: @escaping (Result<Artist, Error>) -> Void){

        guard let url = URL(string: "\(Constants.baseURL)/artist/\(id)") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(Artist.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    func getGenreArtist(with genreId: Int, completion: @escaping (Result<GenreArtists, Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/genre/\(genreId)/artists") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(GenreArtists.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    
    func getArtistAlbums(with artistID: Int, completion: @escaping (Result<ArtistAlbums, Error>) -> Void){
        
        guard let url = URL(string: "\(Constants.baseURL)/artist/\(artistID)/albums") else {return}

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(ArtistAlbums.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()

    }
    
    //MARK: Search Query
    func searchArtistByQuery(query: String ,completion: @escaping (Result<SearchArtists, Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/search/artist?q=\(query)") else {return}
    
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(SearchArtists.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    func searchAlbumByQuery(query: String ,completion: @escaping (Result<SearchAlbums, Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/search/album?q=\(query)") else {return}
    
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(SearchAlbums.self, from: data)
                results.data?.forEach({ item in
                    print("Album Adı: \(item.title)")
                    print("Album Sanatçısı: \(item.artist?.name)")
                    print("Resim URL: \(item.artist?.picture_big)")
                })
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
    
    
    func searchTrackByQuery(query: String ,completion: @escaping (Result<SearchTracks, Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)/search/track?q=\(query)") else {return}
    
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else{
                return
            }
            do{
                let results = try JSONDecoder().decode(SearchTracks.self, from: data)
                completion(.success(results))
            }catch{
                print(String(describing: error)) // <- ✅ Use this for debuging!
                completion(.failure(APIError.failedToGetData))
            }

        }
        task.resume()
    }
}
