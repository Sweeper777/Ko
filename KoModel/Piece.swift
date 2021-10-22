public enum PieceType: Int, Hashable, Codable, CaseIterable {
    case field, empress, burrow, rabbit, hare, moon
}

public enum PlayerColor: Int, Hashable, Codable, CustomStringConvertible {
    case blue, white
    
    @inline(__always)
    var opposingColor: PlayerColor {
        switch self {
        case .blue:
            return .white
        case .white:
            return .blue
        }
    }
    
    @inline(__always)
    public var description: String {
        switch self {
        case .blue:
            return "Blue"
        case .white:
            return "White"
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

public struct PieceStack: Hashable, Codable, Sequence {
    private var pieces: [Piece] = []
    public init() {
        
    }
    
    @inline(__always)
    public var top: Piece? {
        pieces.last
    }
    
    @inline(__always)
    public var bottom: Piece? {
        pieces.first
    }
    
    @inline(__always)
    public var isEmpty: Bool {
        pieces.isEmpty
    }
    
    @inline(__always)
    public var count: Int {
        pieces.count
    }
    
    @inline(__always)
    public func firstIndex(of piece: Piece) -> Int? {
        pieces.firstIndex(of: piece)
    }
    
    @inline(__always)
    public mutating func push(_ piece: Piece) {
        pieces.append(piece)
    }
    
    @inline(__always)
    @discardableResult
    public mutating func pop() -> Piece? {
        pieces.popLast()
    }
    
    @inline(__always)
    public mutating func remove(at index: Int) -> Piece {
        pieces.remove(at: index)
    }
    
    public static func ~=(lhs: PlayerColor, rhs: PieceStack) -> Bool {
        lhs == rhs.top?.color
    }
    public static func ~=(lhs: PieceType, rhs: PieceStack) -> Bool {
        lhs == rhs.top?.type
    }
    
    @inline(__always)
    public func makeIterator() -> IndexingIterator<[Piece]> {
        pieces.makeIterator()
    }
}
