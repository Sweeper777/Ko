public enum PieceType: Int, Hashable, Codable {
    case field, empress, burrow, rabbit, hare, moon
}

public enum PlayerColor: Int, Hashable, Codable {
    case blue, white
    
    var opposingColor: PlayerColor {
        switch self {
        case .blue:
            return .white
        case .white:
            return .blue
        }
    }
}

