public enum PieceType: Int, Hashable, Codable, CaseIterable {
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

public struct PieceStack: Hashable, Codable {
    private var pieces: [Piece] = []
    public init() {
        
    }
    
    public var top: Piece? {
        pieces.last
    }
    
    public var bottom: Piece? {
        pieces.first
    }
    
    public var isEmpty: Bool {
        pieces.isEmpty
    }
    
    public var count: Int {
        pieces.count
    }
    
    public func firstIndex(of piece: Piece) -> Int? {
        pieces.firstIndex(of: piece)
    }
    
    public mutating func push(_ piece: Piece) {
        pieces.append(piece)
    }
    
    @discardableResult
    public mutating func pop() -> Piece? {
        pieces.popLast()
    }
    
    public mutating func remove(at index: Int) -> Piece {
        pieces.remove(at: index)
    }
    
    public static func ~=(lhs: PlayerColor, rhs: PieceStack) -> Bool {
        lhs == rhs.top?.color
    }
    public static func ~=(lhs: PieceType, rhs: PieceStack) -> Bool {
        lhs == rhs.top?.type
    }
}
