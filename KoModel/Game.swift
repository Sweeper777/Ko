public class Game {
    public let bluePlayer = Player(color: .blue)
    public let whitePlayer = Player(color: .white)
    public private(set) var currentTurn = PlayerColor.blue
    public private(set) var board = Board()
    public private(set) var currentTurnNumber = 0
    public private(set) var result = GameResult.notDetermined
    
    private let rules = allRules
    
    public var currentPlayer: Player {
        playerOfColor(currentTurn)
    }
    
    public var currentOpponent: Player {
        playerOfColor(currentTurn.opposingColor)
    }
    
    public func playerOfColor(_ playerColor: PlayerColor) -> Player {
        switch playerColor {
        case .white: return whitePlayer
        case .blue: return bluePlayer
        }
    }
    
    public func makeMove(_ move: Move) -> MoveResult? {
        var moveResult = MoveResult()
        var hasApplicableRules = false
        for rule in rules {
            if rule.isApplicable(to: self, move: move) {
                hasApplicableRules = true
                let ruleApplicationResult = rule.apply(to: self, move: move, pendingMoveResult: &moveResult)
                if ruleApplicationResult == .violation {
                    return nil
                }
            }
        }
        guard hasApplicableRules else {
            return nil
        }
        for removedPieceRecord in moveResult.piecesRemoved.sorted(by: { $0.stackIndex > $1.stackIndex }) {
            let removedPiece = board.removePiece(at: removedPieceRecord.position, stackIndex: removedPieceRecord.stackIndex)
            resolveRemovedPiece(removedPiece)
        }
        if moveResult.hasCapture, let toPosition = moveResult.toPosition,
           let removedPiece = board.removePiece(at: toPosition) {
            resolveRemovedPiece(removedPiece)
        }
        var movedPiece: Piece?
        if let fromPosition = moveResult.fromPosition {
            movedPiece = board.removePiece(at: fromPosition)
        }
        board.conquerFields(positions: moveResult.conqueredPositions)
        if let movedPiece = movedPiece, let toPosition = moveResult.toPosition {
            board.placePiece(movedPiece, at: toPosition)
        }
        if let placedPieceRecord = moveResult.piecePlaced {
            board.placePiece(Piece(currentTurn, placedPieceRecord.pieceType), at: placedPieceRecord.position)
        }
        result = moveResult.gameResult
        if case .notDetermined = result {
            nextTurn()
        }
        return moveResult
    }
    
    private func nextTurn() {
        currentTurn = currentTurn.opposingColor
        if currentTurn == .blue {
            currentTurnNumber += 1
        }
    }
    
}
