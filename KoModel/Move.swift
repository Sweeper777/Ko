public enum Move {
    case placePiece(at: Position)
    case move(from: Position, to: Position)
}

public struct MoveResult {
    public var piecePlaced: PiecePlacementRecord?
    public var piecesRemoved: [PieceRemovalRecord]
    public var conqueredPositions: [Position]
    public var hasCapture: Bool
    public var fromPosition: Position?
    public var toPosition: Position?
    
    public init(piecePlaced: PiecePlacementRecord? = nil,
                piecesRemoved: [PieceRemovalRecord] = [],
                conqueredPositions: [Position] = [],
                hasCapture: Bool = false,
                fromPosition: Position? = nil,
                toPosition: Position? = nil) {
        self.piecePlaced = piecePlaced
        self.piecesRemoved = piecesRemoved
        self.conqueredPositions = conqueredPositions
        self.hasCapture = hasCapture
        self.fromPosition = fromPosition
        self.toPosition = toPosition
    }
}
