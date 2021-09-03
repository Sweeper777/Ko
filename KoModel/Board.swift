public class Board {
    public internal(set) var board = Array2D<PieceStack>(
        columns: GameConstants.boardColumns, rows: GameConstants.boardRows, initialValue: .init()
    )
    
    public internal(set) var piecesPositions: [Piece: Set<Position>] = [:]
    
}
