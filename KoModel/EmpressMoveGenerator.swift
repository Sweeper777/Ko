public enum EmpressMoveGenerator {
    public static func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let neighbours = position.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(
            neighbours.map { .move(from: position, to: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil }
        )
    }
    
    public static func canMove(fromStartingPosition position: Position, game: Game) -> Bool {
        let neighbours = position.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return !neighbours.lazy
            .map { .move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil }
            .isEmpty
    }
}
