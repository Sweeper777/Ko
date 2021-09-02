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

public struct Piece: Hashable, Codable {
    public let type: PieceType
    public let color: PlayerColor
    
    public init(_ color: PlayerColor, _ type: PieceType) {
        self.type = type
        self.color = color
    }
    
    public static func ~=(lhs: PlayerColor, rhs: Piece) -> Bool {
        rhs.color == lhs
    }
    public static func ~=(lhs: PieceType, rhs: Piece) -> Bool {
        rhs.type == lhs
    }
}

