class EmpressCastleRule: PostMoveRule {
    init() {
        super.init("a player wins if they build the empress' castle") {
            game, _, newBoard, result in
            let numberOfFields = newBoard.piecesPositions[Piece(game.currentTurn, .field)]?.count ?? 0
            let numberOfBurrows = newBoard.piecesPositions[Piece(game.currentTurn, .burrow)]?.count ?? 0
            guard let empressPosition = newBoard.piecesPositions[Piece(game.currentTurn, .empress)]?.first,
                  let moonPosition = newBoard.piecesPositions[Piece(game.currentTurn, .moon)]?.first,
                  numberOfFields >= GameConstants.requiredFieldCountForCastle,
                  numberOfBurrows >= GameConstants.initialBurrows,
                  empressPosition.fourNeighbours.contains(moonPosition),
                  empressPosition.fourNeighbours.filter({
                    newBoard.board[safe: $0]?.bottom == Piece(game.currentTurn, .field)
                  }).count == 3 else {
                return .compliance
            }
            let cornerFieldPosition: Position
            switch empressPosition {
            case Position(1, 1):
                cornerFieldPosition = Position(0, 0)
            case Position(GameConstants.boardColumns - 2, 1):
                cornerFieldPosition = Position(GameConstants.boardColumns - 1, 0)
            case Position(1, GameConstants.boardRows - 2):
                cornerFieldPosition = Position(0, GameConstants.boardRows - 1)
            case Position(GameConstants.boardColumns - 2, GameConstants.boardRows - 2):
                cornerFieldPosition = Position(GameConstants.boardColumns - 1, GameConstants.boardRows - 1)
            default:
                return .compliance
            }
            if newBoard[cornerFieldPosition].bottom == Piece(game.currentTurn, .field) {
                result.gameResult = .wins(game.currentTurn)
            }
            return .compliance
        }
    }
}
