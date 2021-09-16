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

