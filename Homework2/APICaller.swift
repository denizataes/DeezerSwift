import Foundation

struct Constants{
    static let baseURL = "https://api.deezer.com"
}

enum APIError: Error{
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
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
}
