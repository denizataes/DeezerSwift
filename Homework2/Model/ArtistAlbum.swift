import Foundation

// MARK: - ArtistAlbums
struct ArtistAlbums: Codable {
    let data: [ArtistAlbum]?
    let total: Int?
    let next: String?
}

// MARK: - ArtistAlbum
struct ArtistAlbum: Codable {
    let id: Int?
    let link, cover, title: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let genre_id, fans: Int?
    let release_date: String?
    let record_type: String?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let type: String?
}

