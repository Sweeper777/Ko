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


fileprivate extension Board {
    func reachableByHare(from: Position, to: Position, depth: Int = 3) -> Bool {
        if from == to {
            return true
        }
        if depth == 0 {
            return false
        }
        visitedPositions.insert(from)
        let neighbours = from.fourNeighbours.filter {
            !visitedPositions.contains($0) && board[safe: $0] != nil &&
                [PieceType.field, .rabbit, .hare, nil].contains(self[$0].top?.type)
        }
        for neighbour in neighbours {
            if reachableByHare(from: neighbour, to: to, depth: depth - 1) {
                return true
            }
        }
        return false
    }
}

var visitedPositions = Set<Position>()
