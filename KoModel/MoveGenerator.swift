public protocol MoveGenerator {
    func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move>
    func canMove(fromStartingPosition position: Position, game: Game) -> Bool
    var pieceType: PieceType { get }
}

// MARK: Empress Move Generator
public struct EmpressMoveGenerator: MoveGenerator {
    public func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let neighbours = position.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(
            neighbours.map { .move(from: position, to: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil }
        )
    }
    
    public func canMove(fromStartingPosition position: Position, game: Game) -> Bool {
        let neighbours = position.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return !neighbours.lazy
            .map { .move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil }
            .isEmpty
    }
    
    public var pieceType: PieceType { .empress }
    
    public init() {}
}

