public class Game {
    public init() {
        ruleResolver.rules.append(contentsOf: allRules)
    }
    
    public let bluePlayer = Player(color: .blue)
    public let whitePlayer = Player(color: .white)
    public internal(set) var currentTurn = PlayerColor.blue
    public internal(set) var board = Board()
    public internal(set) var currentTurnNumber = 0
    public internal(set) var result = GameResult.notDetermined
    
    private let ruleResolver = RuleResolver()
    
    public var currentPlayer: Player {
        playerOfColor(currentTurn)
    }
    
    public var currentOpponent: Player {
        playerOfColor(currentTurn.opposingColor)
    }
    
    public func playerOfColor(_ playerColor: PlayerColor) -> Player {
        switch playerColor {
        case .white: return whitePlayer
        case .blue: return bluePlayer
        }
    }
    
    public func makeMove(_ move: Move) -> MoveResult? {
        guard let moveResult = ruleResolver.resolve(against: move, game: self) else {
            return nil
        }

        let (piecesRemoved, piecesPlaced) = board.applyMoveResult(moveResult, currentTurn: currentTurn)
        piecesRemoved.forEach(resolveRemovedPiece(_:))
        currentPlayer.placementRecords.append(contentsOf: piecesPlaced)
        result = moveResult.gameResult
        if case .notDetermined = result {
            nextTurn()
            guard let empressPosition = board.piecesPositions[Piece(currentTurn, .empress)]?.first else {
                return moveResult
            }
            let stalemate = empressPosition.eightNeighbours.map {
                Move.move(from: empressPosition, to: $0)
            }.allSatisfy { ruleResolver.resolve(against: $0, game: self) != nil }
            if stalemate {
                result = .draw
            }
        }
        
        return moveResult
    }
    
    private func nextTurn() {
        currentTurn = currentTurn.opposingColor
        if currentTurn == .blue {
            currentTurnNumber += 1
        }
    }
    
    private func resolveRemovedPiece(_ removedPiece: Piece) {
        let owner = playerOfColor(removedPiece.color)
        switch removedPiece {
        case .burrow:
            owner.availableBurrows += 1
        case .hare:
            owner.availableHares += 1
        case .moon:
            owner.availableMoons += 1
        case .rabbit:
            owner.availableRabbits += 1
        case .field:
            currentPlayer.availableFields += 1
        default:
            fatalError("This piece cannot be removed!")
        }
    }
    
    public func allPlaceablePieces() -> [Piece] {
        guard result == .notDetermined else { return [] }
        if currentTurnNumber < 4 {
            return [Piece(currentTurn, .field)]
        }
        if currentTurnNumber == 4 {
            return [Piece(currentTurn, .empress)]
        }
        let ruleResolver = RuleResolver()
        ruleResolver.rules = [placePieceFieldRequirementRule, placePieceRemainingPieceRequirementRule]
        var placeablePieceTypes = [PieceType]()
        for pieceType in PieceType.allCases {
            if ruleResolver.resolve(against: .placePiece(pieceType, at: .init(0, 0)), game: self) != nil {
                placeablePieceTypes.append(pieceType)
            }
        }
        return placeablePieceTypes.map { Piece(currentTurn, $0) }
    }
    
}
