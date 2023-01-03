import Foundation

// MARK: - SearchArtists
struct SearchArtists: Codable {
    let data: [SearchArtist]?
    let total: Int?
    let next: String?
}

// MARK: - SearchArtist
struct SearchArtist: Codable {
    let id: Int
    let link, picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let nb_album, nb_fan: Int?
    let radio: Bool?
    let tracklist: String?
    let type: String?

}



