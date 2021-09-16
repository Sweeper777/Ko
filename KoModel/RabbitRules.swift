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

