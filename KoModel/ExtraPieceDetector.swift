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
