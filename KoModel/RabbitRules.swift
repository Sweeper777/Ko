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
            if deltaX != 0 && deltaY == 0 { // horizontal
                xs = Array(stride(from: from.x + deltaX.signum(), to: to.x, by: deltaX.signum()))
                ys = Array(repeating: from.y, count: xs.count)
                
            } else if deltaY != 0 && deltaX == 0 { // vertical
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

class RabbitConquerRule: MoveRule {
    init() {
        super.init("when a rabbit moves diagonally, if all the fields along the path are opponent fields, it conquers all those fields", for: .rabbit) {
            game, from, to, result in
            guard game.board[to].isEmpty else {
                return .violation
            }
            guard from != to else {
                return .violation
            }
            let deltaX = to.x - from.x
            let deltaY = to.y - from.y
            guard abs(deltaX) == abs(deltaY) else {
                return .violation
            }
            let xs = stride(from: from.x + deltaX.signum(), to: to.x, by: deltaX.signum())
            let ys = stride(from: from.y + deltaY.signum(), to: to.y, by: deltaY.signum())
            var conqueredPositions = [Position]()
            for (x, y) in zip(xs, ys) {
                let pos = Position(x, y)
                if game.board[pos].top != Piece(game.currentTurn.opposingColor, .field) {
                    return .violation
                } else {
                    conqueredPositions.append(pos)
                }
            }
            result.conqueredPositions = conqueredPositions
            return .compliance
        }
    }
}

public enum RabbitMoveGenerator {
    public static func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let candidates = candidatePositions(fromStartingPosition: position, game: game)
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(candidates
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil })
    }
    private static func candidatePositions(fromStartingPosition position: Position, game: Game) -> [Position] {
        var candidatePositions = [Position]()
        if let positiveXEmpty = (stride(from: position.x, to: GameConstants.boardColumns, by: 1)
            .map { Position($0, position.y) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.append(positiveXEmpty)
        }
        if let negativeXEmpty = (stride(from: position.x, through: 0, by: -1)
            .map { Position($0, position.y) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.append(negativeXEmpty)
        }
        if let positiveYEmpty = (stride(from: position.y, to: GameConstants.boardRows, by: 1)
            .map { Position(position.x, $0) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.append(positiveYEmpty)
        }
        if let negativeYEmpty = (stride(from: position.y, through: 0, by: -1)
            .map { Position(position.x, $0) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.append(negativeYEmpty)
        }
        if let topLeftEmpty = (sequence(first: position, next: { $0.above().left() })
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(topLeftEmpty)
        }
        if let topRightEmpty = (sequence(first: position, next: { $0.above().right() })
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(topRightEmpty)
        }
        if let bottomLeftEmpty = (sequence(first: position, next: { $0.below().left() })
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(bottomLeftEmpty)
        }
        if let bottomRightEmpty = (sequence(first: position, next: { $0.below().right() })
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(bottomRightEmpty)
        }
        return candidatePositions
    }
}
