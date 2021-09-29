public enum Move: Hashable {
    case placePiece(PieceType, at: Position)
    case move(from: Position, to: Position)
}

public enum GameResult: Hashable {
    case notDetermined, wins(PlayerColor), draw
}

public struct MoveResult: Hashable {
    public var gameResult: GameResult
    public var piecePlaced: PiecePlacementRecord?
    public var piecesRemoved: [PieceRemovalRecord]
    public var conqueredPositions: [Position]
    public var hasCapture: Bool
    public var fromPosition: Position?
    public var toPosition: Position?
    
    public init(gameResult: GameResult = .notDetermined,
                piecePlaced: PiecePlacementRecord? = nil,
                piecesRemoved: [PieceRemovalRecord] = [],
                conqueredPositions: [Position] = [],
                hasCapture: Bool = false,
                fromPosition: Position? = nil,
                toPosition: Position? = nil) {
        self.gameResult = gameResult
        self.piecePlaced = piecePlaced
        self.piecesRemoved = piecesRemoved
        self.conqueredPositions = conqueredPositions
        self.hasCapture = hasCapture
        self.fromPosition = fromPosition
        self.toPosition = toPosition
    }
}
