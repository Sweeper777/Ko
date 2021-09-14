class HareMovementRule: MoveRule {
    init() {
        super.init("hares move a taxicab distance of 3, and can go on top of fields, hares, and rabbits", for: .hare) {
            game, from, to, _ in
            guard [PieceType.field, .rabbit, .hare, nil].contains(game.board[to].top?.type) else {
                return .violation
            }
            guard from != to else {
                return .violation
            }
            visitedPositions = []
            return game.board.reachableByHare(from: from, to: to) ? .compliance : .violation
        }
    }
}

