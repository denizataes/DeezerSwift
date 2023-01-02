import Foundation

// MARK: - Album
struct Album: Codable {
    let id: Int?
    let title: String?
    let upc: String?
    let link, share, cover: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let genre_id: Int?
    let genres: String?
    let label: String?
    let nb_tracks, duration, fans: Int?
    let release_date: String?
    let record_type: String?
    let available: Bool?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics, explicit_content_cover: Int?
    let contributors: [Contributor]?
    let artist: AlbumArtist?
    let type: String?
    let tracks: Tracks?
}

// MARK: - AlbumArtist
struct AlbumArtist: Codable {
    let id: Int?
    let name: String?
    let picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let tracklist: String?
    let type: String?
}
// MARK: - Contributor
struct Contributor: Codable {
    let id: Int?
    let name: String?
    let link, share, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let radio: Bool?
    let tracklist: String?
    let type: String?
    let role: String?
}

// MARK: - Tracks
struct Tracks: Codable {
    let data: [Track]?
}

// MARK: - Track
struct Track: Codable {
    let id: Int?
    let readable: Bool?
    let title, title_short: String?
    let title_version: String?
    let link: String?
    let duration, rank: Int?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics, explicit_content_cover: Int?
    let preview: String?
    let md5_image: String?
    let artist: TrackArtist?
    let album: AlbumClass?
    let type: String?
}

// MARK: - AlbumClass
struct AlbumClass: Codable {
    let id: Int?
    let title: String?
    let cover: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let tracklist: String?
    let type: String?
}

// MARK: - TrackArtist
struct TrackArtist: Codable {
    let id: Int?
    let name: String?
    let tracklist: String?
    let type: String?
}


