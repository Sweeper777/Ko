class RabbitMovementRule: MoveRule {
    init() {
        super.init("rabbits can move to one of its 8 neighbours, given that the square is empty.", for: .rabbit) {
            game, from, to, _ in
            if !game.board[to].isEmpty {
                return .violation
            }
            if from.eightNeighbours.contains(to) {
                return .compliance
            } else {
                return .violation
            }
        }
    }
}

class RabbitJumpRule: MoveRule {
    init() {
        super.init("rabbits can jump horizontally, vertically or diagonally to an empty square, given that all the squares along the path are occupied", for: .rabbit) {
            game, from, to, _ in
            guard game.board[to].isEmpty else {
                return .violation
            }
            guard from != to else {
                return .violation
            }
            let deltaX = to.x - from.x
            let deltaY = to.y - from.y
                    // horizontal/vertical
            guard ((deltaX == 0) != (deltaY == 0)) ||
                    // diagonal
                    abs(deltaX) == abs(deltaY) else {
                return .violation
            }
            
            let xs: [Int]
            let ys: [Int]
            if deltaX != 0 { // horizontal
                xs = Array(stride(from: from.x + deltaX.signum(), to: to.x, by: deltaX.signum()))
                ys = Array(repeating: from.y, count: xs.count)
                
            } else if deltaY != 0 { // vertical
                ys = Array(stride(from: from.y + deltaY.signum(), to: to.y, by: deltaY.signum()))
                xs = Array(repeating: from.x, count: ys.count)
            } else { // diagonal
                xs = Array(stride(from: from.x + deltaX.signum(), to: to.x, by: deltaX.signum()))
                ys = Array(stride(from: from.y + deltaY.signum(), to: to.y, by: deltaY.signum()))
            }
            for (x, y) in zip(xs, ys) {
                let pos = Position(x, y)
                if game.board[pos].isEmpty {
                    return .violation
                }
            }
            return .compliance
        }
    }
}

