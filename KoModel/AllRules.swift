let allRules: [RuleProtocol] = [
    Rule("All moves must be in range of the board", apply: { game, move, _ in
            func inRange(_ position: Position) -> Bool {
                game.board.board[safe: position] != nil
            }
            switch move {
            case .move(from: let pos1, to: let pos2):
                return inRange(pos1) && inRange(pos2) ? .compliance : .violation
            case .placePiece(at: let pos):
                return inRange(pos) ? .compliance : .violation
            }
    }),
]
