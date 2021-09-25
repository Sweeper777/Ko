class MoonMovementRule: MoveRule {
    init() {
        super.init("moons can move to any square that can be reached by moving horizontally and/or vertically", for: .moon) {
            game, from, to, _ in
            guard from != to else {
                return .violation
            }
            if game.board.positionsReachableByMoon(from: from).contains(to) {
                return .compliance
            } else {
                return .violation
            }
        }
    }
}

class MoonCaptureRule: MoveRule {
    init() {
        super.init("moons can capture fields, rabbits and hares", for: .moon, isApplicable: {
            game, _, to in [PieceType.field, .rabbit, .hare].contains(game.board[to].top?.type)
        }) {
            _, _, _, result in
            result.hasCapture = true
            return .compliance
        }
    }
}

fileprivate extension Board {
    func positionsReachableByMoon(from start: Position) -> Set<Position> {
        var reachable = Set<Position>()
        reachable.insert(start)
        var queue = [start]
        while !queue.isEmpty {
            let pos = queue.removeFirst()
            let neighbours = pos.fourNeighbours.filter {
                board[safe: $0]?.isEmpty == true ||
                    (board[safe: $0]?.count == 1 &&
                        [PieceType.field, .rabbit, .hare].contains(board[safe: $0]?.top?.type))
                
            }
            for neighbour in neighbours {
                if reachable.insert(neighbour).inserted, board[neighbour].isEmpty {
                    queue.append(neighbour)
                }
            }
        }
        return reachable
    }
}
