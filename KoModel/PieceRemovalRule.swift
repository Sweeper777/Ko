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

fileprivate func findPiecesToBeRemoved(for player: Player, newBoard: Board) -> [PieceRemovalRecord] {
    let numberOfFields = newBoard.piecesPositions[Piece(player.color, .field)]?.count ?? 0
    let numberOfHares = newBoard.piecesPositions[Piece(player.color, .hare)]?.count ?? 0
    let numberOfRabbits = newBoard.piecesPositions[Piece(player.color, .rabbit)]?.count ?? 0
    let numberOfMoons = newBoard.piecesPositions[Piece(player.color, .moon)]?.count ?? 0
    let numberOfBurrows = newBoard.piecesPositions[Piece(player.color, .burrow)]?.count ?? 0
    let postMovePieceCounts = [
        PieceType.moon: numberOfMoons,
        .hare: numberOfHares,
        .rabbit: numberOfRabbits,
        .burrow: numberOfBurrows
    ]
    let extraPieces = detectExtraPiece(
        fieldCount: numberOfFields,
        piecesCounts: postMovePieceCounts,
        placementRecords: player.placementRecords
    )
    var retVal = [PieceRemovalRecord]()
    for (pieceType, count) in extraPieces {
        if pieceType == .burrow {
            let placementRecords = player.placementRecords.filter { $0.pieceType == .burrow }.suffix(count)
            retVal.append(contentsOf: placementRecords.map { PieceRemovalRecord(position: $0.position, stackIndex: 0) })
        } else {
            let positions = newBoard.piecesPositions[Piece(player.color, pieceType), default: []].prefix(count)
            if pieceType == .hare {
                let piece = Piece(player.color, pieceType)
                retVal.append(contentsOf: positions.map { PieceRemovalRecord(position: $0, stackIndex: newBoard[$0].firstIndex(of: piece)!) })
            } else {
                retVal.append(contentsOf: positions.map { PieceRemovalRecord(position: $0, stackIndex: 0) })
            }
        }
    }
    return retVal
}
