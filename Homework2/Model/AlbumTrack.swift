import Foundation

// MARK: - AlbumTrack
struct AlbumTracks: Codable {
    let data: [AlbumTrack]?
    let total: Int?
}

// MARK: - Datum
struct AlbumTrack: Codable {
    let id: Int?
    let readable: Bool?
    let title, title_short, title_version, isrc: String?
    let link: String?
    let duration: Int?
    let track_position, disk_number: Int?
    let rank: Int?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics, explicit_content_cover: Int?
    let preview: String?
    let md5_image: String?
    let artist: AlbumTrackArtist?
    let type: String?
}

// MARK: - TrackArtist
struct AlbumTrackArtist: Codable {
    let id: Int?
    let name: String?
    let tracklist: String?
    let type: String?
}
