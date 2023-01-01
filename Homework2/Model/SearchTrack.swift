//https://api.deezer.com/search/track?q=tarkan
import Foundation

// MARK: - SearchTracks
struct SearchTracks: Codable {
    let data: [SearchTrack]?
    let total: Int?
    let next: String?
}

// MARK: - SearchTrack
struct SearchTrack: Codable {
    let id: Int?
    let readable: Bool?
    let title, title_short, title_version: String?
    let link: String?
    let duration, rank: Int?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics, explicit_content_cover: Int?
    let preview: String?
    let md5_image: String?
    let artist: SearchTrackArtist?
    let album: SearchTrackAlbum?
    let type: String?
}

// MARK: - SearchTrackAlbum
struct SearchTrackAlbum: Codable {
    let id: Int?
    let cover, title: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let tracklist: String?
    let type: String?
}

// MARK: - SearchTrackArtist
struct SearchTrackArtist: Codable {
    let id: Int?
    let name: String?
    let link, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let tracklist: String?
    let type: String?
}
