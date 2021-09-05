public enum Move {
    case placePiece(at: Position)
    case move(from: Position, to: Position)
}

public struct MoveResult {
    public let piecePlaced: PiecePlacementRecord?
    public let pieceRemovedPosition: (boardPos: Position, stackIndex: Int)?
    public let conqueredPositions: [Position]?
    public let hasCapture: Bool
    public let fromPosition: Position?
    public let toPosition: Position?
    
    public init(piecePlaced: PiecePlacementRecord? = nil,
                pieceRemovedPosition: (boardPos: Position, stackIndex: Int)? = nil,
                conqueredPositions: [Position]? = nil,
                hasCapture: Bool = false,
                fromPosition: Position? = nil,
                toPosition: Position? = nil) {
        self.piecePlaced = piecePlaced
        self.pieceRemovedPosition = pieceRemovedPosition
        self.conqueredPositions = conqueredPositions
        self.hasCapture = hasCapture
        self.fromPosition = fromPosition
        self.toPosition = toPosition
    }
}
