import Foundation

enum Category: String, CaseIterable{
    case album
    case track
    case artist
    
    var buttonTitle: String{
        switch self{
        case .album: return "Albüm"
        case .track: return "Şarkı"
        case .artist: return "Artist"
        }
    }
}
