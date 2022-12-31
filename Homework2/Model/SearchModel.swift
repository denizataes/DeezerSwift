// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let artistAlbum = try? newJSONDecoder().decode(ArtistAlbum.self, from: jsonData)

import Foundation

// MARK: - ArtistAlbum
struct SearchModel: Codable {
    let data: [Search]?
    let total: Int?
    let next: String?
}

// MARK: - Datum
struct Search: Codable {
    let id: Int
    let link, cover, title: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let genre_id, nb_tracks: Int?
    let record_type: String?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let artist: ArtistSearch?
    let type: String?

}


struct ArtistSearch: Codable {
    let id: Int
    let name: String?
    let link, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let tracklist: String?
    let type: String?
}
