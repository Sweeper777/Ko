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
            }
    }),
]
