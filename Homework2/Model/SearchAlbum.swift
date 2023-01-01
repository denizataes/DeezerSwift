//https://api.deezer.com/search/album?q=tarkan
import Foundation

// MARK: - SearchAlbums
struct SearchAlbums: Codable {
    let data: [SearchAlbum]?
    let total: Int?
    let next: String?
}

// MARK: - SearchAlbum
struct SearchAlbum: Codable {
    let id: Int?
    let link, cover, title: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let genre_id, nb_tracks: Int?
    let record_type: String?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let artist: SearchAlbumArtist?
    let type: String?
}

// MARK: - SearchAlbumArtist
struct SearchAlbumArtist: Codable {
    let id: Int?
    let link, picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let tracklist: String?
    let type: String?
}

