let allRules: [RuleProtocol] = [
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
    PlacePieceRule("pieces can only be placed on empty squares", apply: {
        game, placedPiece, _ in
        if game.board[placedPiece.position].isEmpty {
            return .compliance
        } else {
            return .violation
        }
    }),
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
        if placedPiece.position.fourNeighbours.allSatisfy({ game.board.board[safe: $0]?.top == Piece(game.currentTurn, .field) }) {
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
        if position.eightNeighbours.allSatisfy({ game.board.board[safe: $0]?.top?.type != .empress }) {
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
]
