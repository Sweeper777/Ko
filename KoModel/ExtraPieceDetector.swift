func detectExtraPiece(fieldCount: Int,
                      piecesCounts: [PieceType: Int],
                      placementRecords: [PiecePlacementRecord]) -> [PieceType: Int] {
    var retVal = [PieceType: Int]()
    if fieldCount < GameConstants.moonThreshold && piecesCounts[.moon, default: 0] > 0 {
        retVal[.moon] = piecesCounts[.moon]
    }
    if fieldCount < GameConstants.thirdBurrowThreshold && piecesCounts[.burrow, default: 0] > 2 {
        retVal[.burrow] = piecesCounts[.burrow]! - 2
    }
    if fieldCount < GameConstants.secondBurrowThreshold && piecesCounts[.burrow, default: 0] > 1 {
        retVal[.burrow] = piecesCounts[.burrow]! - 1
    }
    if fieldCount < GameConstants.firstBurrowThreshold && piecesCounts[.burrow, default: 0] > 0 {
        retVal[.burrow] = piecesCounts[.burrow]
    }
    switch (piecesCounts[.rabbit, default: 0], piecesCounts[.hare, default: 0]) {
    case (1, 0):
        if fieldCount < GameConstants.firstRabbitHareThreshold {
            retVal[.rabbit] = 1
        }
    case (0, 1):
        if fieldCount < GameConstants.firstRabbitHareThreshold {
            retVal[.hare] = 1
        }
    case (1, 1):
        if fieldCount < GameConstants.firstRabbitHareThreshold {
            retVal[.hare] = 1
            retVal[.rabbit] = 1
        } else if fieldCount < GameConstants.secondRabbitHareThreshold {
            let mostRecentlyPlacedType = placementRecords.filter { $0.pieceType == .hare || $0.pieceType == .rabbit }.last?.pieceType
            retVal[mostRecentlyPlacedType ?? .hare] = 1
        }
    case (let rabbits, let hares):
        retVal[.hare] = hares
        retVal[.rabbit] = rabbits
    }
    return retVal
}

let placePieceFieldRequirementRule =
    PlacePieceRule("a player can place different pieces depending on how many fields they have", isApplicable: {
        _, placedPiece in placedPiece.pieceType != .empress && placedPiece.pieceType != .field
    }, apply: {
        game, placedPiece, _ in
        let numberOfFields = game.board.piecesPositions[Piece(game.currentTurn, .field)]?.count ?? 0
        let numberOfHares = game.board.piecesPositions[Piece(game.currentTurn, .hare)]?.count ?? 0
        let numberOfRabbits = game.board.piecesPositions[Piece(game.currentTurn, .rabbit)]?.count ?? 0
        let numberOfMoons = game.board.piecesPositions[Piece(game.currentTurn, .moon)]?.count ?? 0
        let numberOfBurrows = game.board.piecesPositions[Piece(game.currentTurn, .burrow)]?.count ?? 0
        var postMovePieceCounts = [
            PieceType.moon: numberOfMoons,
            .hare: numberOfHares,
            .rabbit: numberOfRabbits,
            .burrow: numberOfBurrows
        ]
        postMovePieceCounts[placedPiece.pieceType]! += 1
        let extraPieces = detectExtraPiece(
            fieldCount: numberOfFields,
            piecesCounts: postMovePieceCounts,
            placementRecords: game.currentPlayer.placementRecords
        )
        if extraPieces.values.contains(where: { $0 > 0 }) {
            return .violation
        } else {
            return .compliance
        }
    })
let placePieceRemainingPieceRequirementRule =
    PlacePieceRule("a player can only place a piece if they have that piece", apply: {
        game, placedPiece, _ in
        switch placedPiece.pieceType {
        case .field:
            return game.currentPlayer.availableFields > 0 ? .compliance : .violation
        case .empress:
            return (game.board.piecesPositions[Piece(game.currentTurn, .empress)]?.count ?? 0) > 0 ? .violation : .compliance
        case .burrow:
            return game.currentPlayer.availableBurrows > 0 ? .compliance : .violation
        case .rabbit:
            return game.currentPlayer.availableRabbits > 0 ? .compliance : .violation
        case .hare:
            return game.currentPlayer.availableHares > 0 ? .compliance : .violation
        case .moon:
            return game.currentPlayer.availableMoons > 0 ? .compliance : .violation
        }
    })
