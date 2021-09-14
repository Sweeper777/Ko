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

class HareConquerRule: MoveRule {
    init() {
        super.init("hares can move horizontally or vertically to an empty square, conquering all the fields along the path. All fields along the path must be opponent fields.", for: .hare) {
            game, from, to, result in
            guard game.board[to].isEmpty else {
                return .violation
            }
            let deltaX = to.x - from.x
            let deltaY = to.y - from.y
            guard (deltaX == 0) != (deltaY == 0) else {
                return .violation
            }
            var conqueredPositions = [Position]()
            if deltaX != 0 {
                for x in stride(from: from.x + deltaX.signum(), to: to.x, by: deltaX.signum()) {
                    let pos = Position(x, from.y)
                    if game.board[pos].top != Piece(game.currentTurn.opposingColor, .field) {
                        return .violation
                    } else {
                        conqueredPositions.append(pos)
                    }
                }
            } else {
                for y in stride(from: from.y + deltaY.signum(), to: to.y, by: deltaY.signum()) {
                    let pos = Position(from.x, y)
                    if game.board[pos].top != Piece(game.currentTurn.opposingColor, .field) {
                        return .violation
                    } else {
                        conqueredPositions.append(pos)
                    }
                }
            }
            result.conqueredPositions = conqueredPositions
            return .compliance
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
