public enum EmpressMoveGenerator {
    public static func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let neighbours = position.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(
            neighbours.map { .move(from: position, to: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil }
        )
    }
}
