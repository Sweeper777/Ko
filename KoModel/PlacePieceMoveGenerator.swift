public enum PlacePieceMoveGenerator {
    public static func generateMoves(forPlacing piece: PieceType, game: Game) -> Set<Move> {
        if game.currentTurnNumber == 0, piece == .field {
            switch game.currentTurn {
            case .blue:
                return [
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2 - 1, GameConstants.boardRows / 2)),
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2, GameConstants.boardRows / 2)),
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2 + 1, GameConstants.boardRows / 2)),
                ]
            case .white:
                return [
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2 - 1, GameConstants.boardRows / 2 - 1)),
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2, GameConstants.boardRows / 2 - 1)),
                    .placePiece(.field, at: .init(GameConstants.boardColumns / 2 + 1, GameConstants.boardRows / 2 - 1)),
                ]
            }
        }
        if (game.currentTurnNumber < 4 && piece == .field) || (game.currentTurnNumber == 4 && piece == .empress) {
            let playersFieldPositions = game.board.piecesPositions[Piece(game.currentTurn, .field)] ?? []
            let playersFieldNeighbours = Set(playersFieldPositions.flatMap { $0.eightNeighbours })
            let ruleResolver = RuleResolver()
            ruleResolver.rules = gameBeginningRulesOnly
            return Set(playersFieldNeighbours.map { Move.placePiece(piece, at: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil })
        }
        guard let empressPosition = game.board.piecesPositions[Piece(game.currentTurn, .empress)]?.first else {
            return []
        }
        let empressNeighbours = empressPosition.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        
        if piece == .burrow {
            let candidateLocations = Set(empressNeighbours.flatMap { $0.fourNeighbours })
            return Set(candidateLocations.map { Move.placePiece(.burrow, at: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil })
        } else {
            return Set(empressNeighbours.map { Move.placePiece(piece, at: $0) }.filter { ruleResolver.resolve(against: $0, game: game) != nil })
        }
    }
    
    public static func canPlacePiece(_ piece: PieceType, game: Game) -> Bool {
        if game.currentTurnNumber < 4 && piece == .field {
            return true
        }
        if game.currentTurnNumber == 4 && piece == .empress {
            let playersFieldPositions = game.board.piecesPositions[Piece(game.currentTurn, .field)] ?? []
            let playersFieldNeighbours = Set(playersFieldPositions.flatMap { $0.eightNeighbours })
            let ruleResolver = RuleResolver()
            ruleResolver.rules = gameBeginningRulesOnly
            return !playersFieldNeighbours.lazy
                .map { Move.placePiece(piece, at: $0) }
                .filter { ruleResolver.resolve(against: $0, game: game) != nil }
                .isEmpty
        }
        guard let empressPosition = game.board.piecesPositions[Piece(game.currentTurn, .empress)]?.first else {
            return false
        }
        let empressNeighbours = empressPosition.eightNeighbours
        let ruleResolver = RuleResolver()
        ruleResolver.rules = allRules
        
        if piece == .burrow {
            let candidateLocations = Set(empressNeighbours.flatMap { $0.fourNeighbours })
            return !candidateLocations.lazy
                .map { Move.placePiece(.burrow, at: $0) }
                .filter { ruleResolver.resolve(against: $0, game: game) != nil }
                .isEmpty
        } else {
            return !empressNeighbours.lazy
                .map { Move.placePiece(piece, at: $0) }
                .filter { ruleResolver.resolve(against: $0, game: game) != nil }
                .isEmpty
        }
    }
}
