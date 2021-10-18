public protocol MoveGenerator {
    func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move>
    func canMove(fromStartingPosition position: Position, game: Game) -> Bool
    var pieceType: PieceType { get }
}

