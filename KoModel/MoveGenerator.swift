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

// MARK: Rabbit Move Generator
public struct RabbitMoveGenerator : MoveGenerator {
    public func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let candidates = candidatePositions(fromStartingPosition: position, game: game)
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(candidates
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil })
    }
    
    public func canMove(fromStartingPosition position: Position, game: Game) -> Bool {
        let candidates = candidatePositions(fromStartingPosition: position, game: game)
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return !candidates.lazy
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil }
            .isEmpty
    }
    
    private func candidatePositions(fromStartingPosition position: Position, game: Game) -> [Position] {
        var candidatePositions = [Position]()
        let longerAxis = max(GameConstants.boardColumns, GameConstants.boardRows)
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
            .prefix(longerAxis)
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(topLeftEmpty)
        }
        if let topRightEmpty = (sequence(first: position, next: { $0.above().right() })
            .prefix(longerAxis)
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(topRightEmpty)
        }
        if let bottomLeftEmpty = (sequence(first: position, next: { $0.below().left() })
            .prefix(longerAxis)
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(bottomLeftEmpty)
        }
        if let bottomRightEmpty = (sequence(first: position, next: { $0.below().right() })
            .prefix(longerAxis)
            .first { game.board.board[safe: $0]?.isEmpty == true }) {
            candidatePositions.append(bottomRightEmpty)
        }
        return candidatePositions
    }
    
    public var pieceType: PieceType { .rabbit }
    
    public init() {}
}

// MARK: Moon Move Generator
public struct MoonMoveGenerator : MoveGenerator {
    public func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        let allPositionsReachable = game.board.positionsReachableByMoon(from: position)
        let candidatePositions = allPositionsReachable.filter { position in
            position.eightNeighbours.contains {
                game.board.board[safe: $0] != nil &&
                    !game.board[$0].isEmpty &&
                    game.board[$0].top != Piece(game.currentTurn, .moon)
            }
        }
        let ruleResolver = RuleResolver()
        ruleResolver.rules = rulesWithoutMovementRule
        return Set(candidatePositions
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil })
    }
    
    public func canMove(fromStartingPosition position: Position, game: Game) -> Bool {
        let allPositionsReachable = game.board.positionsReachableByMoon(from: position)
        let candidatePositions = allPositionsReachable.lazy.filter { position in
            position.eightNeighbours.contains {
                game.board.board[safe: $0] != nil &&
                    !game.board[$0].isEmpty &&
                    game.board[$0].top != Piece(game.currentTurn, .moon)
            }
        }
        let ruleResolver = RuleResolver()
        ruleResolver.rules = rulesWithoutMovementRule
        return !candidatePositions
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil }
            .isEmpty
    }
    
    public var pieceType: PieceType { .moon }
    
    public init() {}
}

// MARK: Hare Move Generator
public struct HareMoveGenerator: MoveGenerator {
    public func generateMoves(fromStartingPosition position: Position, game: Game) -> Set<Move> {
        
        let candidates = candidatePositions(fromStartingPosition: position, game: game)
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return Set(candidates
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil })
    }
    
    public func canMove(fromStartingPosition position: Position, game: Game) -> Bool {
        let candidates = candidatePositions(fromStartingPosition: position, game: game)
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        return !candidates.lazy
            .map { Move.move(from: position, to: $0) }
            .filter { ruleResolver.resolve(against: $0, game: game) != nil }
            .isEmpty
    }
    
    public func candidatePositions(fromStartingPosition position: Position, game: Game) -> Set<Position> {
        var candidatePositions = game.board.positionsReachableByHare(from: position)
        if let positiveXEmpty = (stride(from: position.x, to: GameConstants.boardColumns, by: 1)
            .map { Position($0, position.y) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.insert(positiveXEmpty)
        }
        if let negativeXEmpty = (stride(from: position.x, through: 0, by: -1)
            .map { Position($0, position.y) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.insert(negativeXEmpty)
        }
        if let positiveYEmpty = (stride(from: position.y, to: GameConstants.boardRows, by: 1)
            .map { Position(position.x, $0) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.insert(positiveYEmpty)
        }
        if let negativeYEmpty = (stride(from: position.y, through: 0, by: -1)
            .map { Position(position.x, $0) }
            .first { game.board[$0].isEmpty }) {
            candidatePositions.insert(negativeYEmpty)
        }
        return candidatePositions
    }
    
    public var pieceType: PieceType { .hare }
    
    public init() {}
}
