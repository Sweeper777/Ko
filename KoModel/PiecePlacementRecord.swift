public struct PiecePlacementRecord: Hashable, Codable {
    public let pieceType: PieceType
    public let position: Position
    
    public init(pieceType: PieceType, position: Position) {
        self.pieceType = pieceType
        self.position = position
    }
}

public struct PieceRemovalRecord: Hashable, Codable {
    public let position: Position
    public let stackIndex: Int
    
    public init(position: Position, stackIndex: Int) {
        self.position = position
        self.stackIndex = stackIndex
    }
}
