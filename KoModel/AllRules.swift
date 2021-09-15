let allRules: [RuleProtocol] = [
    // MARK: Basic Rules
    Rule("all moves must be in range of the board", apply: { game, move, _ in
        func inRange(_ position: Position) -> Bool {
            game.board.board[safe: position] != nil
        }
        switch move {
        case .move(from: let pos1, to: let pos2):
            return inRange(pos1) && inRange(pos2) ? .compliance : .violation
        case .placePiece(_, at: let pos):
            return inRange(pos) ? .compliance : .violation
        }
    }),
    MoveRule("moves can move pieces", apply: { _, from, to, result in
        result.fromPosition = from
        result.toPosition = to
        return .compliance
    }),
    PlacePieceRule("moves can place pieces", apply: { _, piecePlaced, result in
        result.piecePlaced = piecePlaced
        return .compliance
    }),
    MoveRule("the movable pieces are empress, rabbit, hare, moon", apply: { game, from, _, _ in
        switch game.board[from] {
        case .empress, .rabbit, .hare, .moon:
            return .compliance
        default:
            return .violation
        }
    }),
    MoveRule("players can only move their own pieces", apply: { game, from, _, _ in
        if game.board[from].top?.color == game.currentTurn {
            return .compliance
        } else {
            return .violation
        }
    }),
    PlacePieceRule("pieces can only be placed on empty squares", apply: {
        game, placedPiece, _ in
        if game.board[placedPiece.position].isEmpty {
            return .compliance
        } else {
            return .violation
        }
    }),
    // MARK: Game Beginning
    PlacePieceRule("first field must be placed on the central squares on the first turn") {
        game, _ in game.currentTurnNumber == 0
    } apply: { game, placedPiece, _ in
        if placedPiece.pieceType != .field {
            return .violation
        }
        let validXRange = (GameConstants.boardColumns / 2 - 1)...(GameConstants.boardColumns / 2 + 1)
        let validY: Int
        switch game.currentTurn {
        case .blue:
            validY = GameConstants.boardRows / 2
        case .white:
            validY = GameConstants.boardRows / 2 - 1
        }
        if validXRange.contains(placedPiece.position.x) && validY == placedPiece.position.y {
            return .compliance
        } else {
            return .violation
        }
    },
    PlacePieceRule("the second to the fourth fields must be placed connected to the grassland via 4-neighbours") {
        game, _ in (1...3).contains(game.currentTurnNumber)
    } apply: { game, placedPiece, _ in
        if placedPiece.pieceType != .field {
            return .violation
        }
        if placedPiece.position.fourNeighbours.allSatisfy({ game.board.board[safe: $0]?.top != Piece(game.currentTurn, .field) }) {
            return .violation
        }
        let validYRange: Range<Int>
        switch game.currentTurn {
        case .blue:
            validYRange = (GameConstants.boardRows / 2)..<GameConstants.boardRows
        case .white:
            validYRange = 0..<(GameConstants.boardRows / 2)
        }
        if validYRange.contains(placedPiece.position.y) {
            return .compliance
        } else {
            return .violation
        }
    },
    PlacePieceRule("after 4 moves, the fields must form an L shape") {
        game, _ in game.currentTurnNumber == 3
    } apply: { game, placedPiece, _ in
        func countNeighbours(_ position: Position) -> Int {
            var count = 0
            for neighbour in position.eightNeighbours {
                if game.board.board[safe: neighbour]?.top == Piece(game.currentTurn, .field) ||
                    neighbour == placedPiece.position {
                    count += 1
                }
            }
            return count
        }
        let allFieldPositions = (game.board.piecesPositions[Piece(game.currentTurn, .field)] ?? []) + [placedPiece.position]
        let isL = allFieldPositions.contains { countNeighbours($0) == 1 } && allFieldPositions.contains { countNeighbours($0) == 3 }
        return isL ? .compliance : .violation
    },
    ExistenceRule("there must not be other empresses in the 8-neighbourhood of an empress", for: .empress, apply: {
        game, position, _ in
        if position.eightNeighbours.allSatisfy({ game.board.board[safe: $0]?.top != Piece(game.currentTurn.opposingColor, .empress) }) {
            return .compliance
        } else {
            return .violation
        }
    }),
    PlacePieceRule("the fifth move must place an empress") {
        game, _ in game.currentTurnNumber == 4
    } apply: { game, placedPiece, _ in
        if placedPiece.pieceType != .empress {
            return .violation
        }
        let validYRange: Range<Int>
        switch game.currentTurn {
        case .blue:
            validYRange = (GameConstants.boardRows / 2)..<GameConstants.boardRows
        case .white:
            validYRange = 0..<(GameConstants.boardRows / 2)
        }
        if validYRange.contains(placedPiece.position.y) {
            return .compliance
        } else {
            return .violation
        }
    },
    // MARK: Existence Rules
    ExistenceRule("there must not an opponent moon in the 4-neighbourhood of an empress", for: .empress, apply: {
        game, position, _ in
        if position.fourNeighbours.allSatisfy({ game.board.board[safe: $0]?.top != Piece(game.currentTurn.opposingColor, .moon) }) {
            return .compliance
        } else {
            return .violation
        }
    }),
    ExistenceRule("there must not an opponent empress in the 4-neighbourhood of a moon", for: .moon, apply: {
        game, position, _ in
        if position.fourNeighbours.allSatisfy({ game.board.board[safe: $0]?.top != Piece(game.currentTurn.opposingColor, .empress) }) {
            return .compliance
        } else {
            return .violation
        }
    }),
    ExistenceRule("there must not be an opponent moon in the 8-neighbourhood of a moon", for: .moon, apply: {
        game, position, _ in
        if position.eightNeighbours.allSatisfy({ game.board.board[safe: $0]?.top != Piece(game.currentTurn.opposingColor, .moon) }) {
            return .compliance
        } else {
            return .violation
        }
    }),
    ExistenceRule("burrows must be 5 squares away from any other burrows", for: .burrow, apply: {
        game, position, _ in
        if game.board.hasPiece(Piece(.blue, .burrow), within: 5, of: position) ||
            game.board.hasPiece(Piece(.white, .burrow), within: 5, of: position) {
            return .violation
        } else {
            return .compliance
        }
    }).ifViolatedApply(
        ExistenceRule("if it is the first burrow, the burrow just needs to be 3 squares away", for: .burrow,
          apply: { game, position, _ in
            if !game.currentPlayer.placementRecords.contains(where: { $0.pieceType == .burrow }) {
                return game.board.hasPiece(Piece(.white, .burrow), within: 3, of: position) ||
                        game.board.hasPiece(Piece(.blue, .burrow), within: 3, of: position) ?
                    .violation : .compliance
            } else {
                return .violation
            }
          })),
    // MARK: Placing Pieces
    PlacePieceRule("pieces can only be placed near the player's empress", isApplicable: {
        game, _ in game.currentTurnNumber > 4
    }, apply: { game, placedPiece, _ in
        if placedPiece.position.eightNeighbours.contains(where: { game.board.board[safe: $0]?.top == Piece(game.currentTurn, .empress) }) {
            return .compliance
        } else {
            return .violation
        }
    }).ifViolatedApply(PlacePieceRule("if the piece placed is a burrow, then it must be touching the eight fields around the burrow", isApplicable: {
        _, placedPiece in placedPiece.pieceType == .burrow
    }, apply: { game, placedPiece, result in
        let touching = (game.board.piecesPositions[Piece(game.currentTurn, .empress)] ?? []).contains {
            (abs(placedPiece.position.x - $0.x) == 2) !=
                (abs(placedPiece.position.y - $0.y) == 2) &&
                abs(placedPiece.position.x - $0.x) <= 2 &&
                abs(placedPiece.position.y - $0.y) <= 2
        }
        return touching ? .compliance : .violation
    })),
    PlacePieceRule("a player can place different pieces depending on how many fields they have", isApplicable: {
        _, placedPiece in placedPiece.pieceType != .empress && placedPiece.pieceType != .field
    }, apply: {
        game, placedPiece, _ in
        let numberOfFields = game.board.piecesPositions[Piece(game.currentTurn, .field)]?.count ?? 0
        let numberOfHares = game.board.piecesPositions[Piece(game.currentTurn, .hare)]?.count ?? 0
        let numberOfRabbits = game.board.piecesPositions[Piece(game.currentTurn, .rabbit)]?.count ?? 0
        let numberOfMoons = game.board.piecesPositions[Piece(game.currentTurn, .moon)]?.count ?? 0
        let numberOfBurrows = game.board.piecesPositions[Piece(game.currentTurn, .burrow)]?.count ?? 0
        switch placedPiece.pieceType {
        case .field, .empress:
            return .compliance
        case .burrow:
            if (numberOfFields >= 8 && numberOfBurrows < 1) ||
                (numberOfFields >= 22 && numberOfBurrows < 2) ||
                (numberOfFields >= 36 && numberOfBurrows < 3) {
                return .compliance
            } else {
                return .violation
            }
        case .rabbit, .hare:
            if (numberOfFields >= 14 && numberOfRabbits + numberOfHares < 1) ||
                (numberOfFields >= 28 && numberOfRabbits + numberOfRabbits < 2) {
                return .compliance
            } else {
                return .violation
            }
        case .moon:
            if (numberOfFields >= 43 && numberOfMoons < 1) {
                return .compliance
            } else {
                return .violation
            }
        }
    }),
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
    }),
    PlacePieceRule("a burrow can be placed in a position if that position is surrounded by fields of either color. When it is placed, the fields are conquered.", isApplicable: {
        _, placedPiece in placedPiece.pieceType == .burrow
    }, apply: { game, placedPiece, result in
        let neighbours = placedPiece.position.eightNeighbours
        for neighbour in neighbours {
            let neighbourPiece = game.board.board[safe: neighbour]?.bottom
            if neighbourPiece?.type != .field {
                return .violation
            }
            if neighbourPiece?.color == game.currentTurn.opposingColor {
                result.conqueredPositions.append(neighbour)
            }
        }
        return .compliance
    }),
    // MARK: Empress Move Rules
    MoveRule("empress can move to one of its 8 neighbours that are empty", for: .empress, apply: {
        game, from, to, _ in
        if !game.board[to].isEmpty {
            return .violation
        }
        if from.eightNeighbours.contains(to) {
            return .compliance
        } else {
            return .violation
        }
    }),
    HareConquerRule().ifViolatedApply(HareMovementRule()),
    // MARK: Post-move Rules
    PostMoveRule("after every move, the grassland must be connected", apply: {
        _, move, newBoard, _ in
        let startPosition: Position
        switch move {
        case .move(from: _, to: let to):
            startPosition = to
        case .placePiece(_, at: let at):
            startPosition = at
        }
        if newBoard.isExactlyOneGrassland(startPosition: startPosition) {
            return .compliance
        } else {
            return .violation
        }
    }),
    PostMoveRule("a player must not trap their empress", isApplicable: {
        game, move in
        if case .placePiece = move, game.board.piecesPositions[Piece(game.currentTurn, .empress)]?.first != nil {
            return true
        } else {
            return false
        }
    }, apply: { game, _, newBoard, _ in
        let neighbours = newBoard.piecesPositions[Piece(game.currentTurn, .empress)]!.first!.eightNeighbours
        if neighbours.allSatisfy({
            newBoard.board[safe: $0] == nil ||
            newBoard[$0].bottom?.type == .field ||
            newBoard[$0].bottom?.type == .burrow }) {
            return .violation
        } else {
            return .compliance
        }
    })
]

fileprivate extension Board {
    func hasPiece(_ piece: Piece, within range: Int, of position: Position) -> Bool {
        (piecesPositions[piece] ?? []).contains { abs(position.x - $0.x) < range && abs(position.y - $0.y) < range }
    }
}
