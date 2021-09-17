class PieceRemovalRule: PostMoveRule {
    init() {
        super.init("some pieces may be removed if the number of fields a player has is below certain levels") {
            game, _, newBoard, result in
            result.piecesRemoved = findPiecesToBeRemoved(for: game.bluePlayer, newBoard: newBoard) +
                findPiecesToBeRemoved(for: game.whitePlayer, newBoard: newBoard)
            return .compliance
        }
    }
}

