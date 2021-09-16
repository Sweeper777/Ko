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

