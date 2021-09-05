public struct PiecePlacementRecord: Hashable, Codable {
    public let pieceType: PieceType
    public let position: Position
    
    public init(pieceType: PieceType, position: Position) {
        self.pieceType = pieceType
        self.position = position
    }
}
