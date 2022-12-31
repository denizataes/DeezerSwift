import Foundation

enum ListSection {
    case artist([ListItem])
    case album([ListItem])
    case tracks([ListItem])
    
    var items: [ListItem] {
        switch self {
        case .artist(let items),
                .album(let items),
                .tracks(let items):
            return items
        }
    }
    
    var count: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .artist:
            return "Artist"
        case .album:
            return "Album"
        case .tracks:
            return "Track"
        }
    }
}
