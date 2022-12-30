
import Foundation

// MARK: - Artist
struct Artist: Codable {
    let id: Int?
    let link, name, share, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let nb_album, nb_fan: Int?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}

// MARK: - GenreArtist
struct GenreArtists: Codable {
    let data: [GenreArtist]?
}

// MARK: - GenreArtist
struct GenreArtist: Codable {
    let id: Int?
    let picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}


