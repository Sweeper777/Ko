public class Game {
    public init() {
        bluePlayer = Player(color: .blue)
        whitePlayer = Player(color: .white)
    }
    
    public init(copyOf game: Game) {
        bluePlayer = Player(copyOf: game.bluePlayer)
        whitePlayer = Player(copyOf: game.whitePlayer)
        currentTurn = game.currentTurn
        board = game.board
        currentTurnNumber = game.currentTurnNumber
        result = game.result
    }
    
    public let bluePlayer: Player
    public let whitePlayer: Player
    public internal(set) var currentTurn = PlayerColor.blue
    public internal(set) var board = Board()
    public internal(set) var currentTurnNumber = 0
    public internal(set) var result = GameResult.notDetermined
    
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
        makeMove(move, rules: allRules)
    }
    
    public func makeMoveUnchecked(_ move: Move) -> MoveResult? {
        makeMove(move, rules: rulesThatModifyResultOnly)
    }
    
    private func makeMove(_ move: Move, rules: [RuleProtocol]) -> MoveResult? {
        let ruleResolver = RuleResolver()
        ruleResolver.rules = rules
        guard let moveResult = ruleResolver.resolve(against: move, game: self) else {
            return nil
        }

        let (piecesRemoved, piecesPlaced) = board.applyMoveResult(moveResult, currentTurn: currentTurn)
        piecesRemoved.forEach(resolveRemovedPiece(_:))
        currentPlayer.placementRecords.append(contentsOf: piecesPlaced)
        piecesPlaced.forEach(resolvePlacedPiece(_:))
        result = moveResult.gameResult
        if case .notDetermined = result {
            nextTurn()
            let stalemate = !hasAnyMoves()
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
    
    private func resolvePlacedPiece(_ placedPiece: PiecePlacementRecord) {
        switch placedPiece.pieceType {
        case .burrow:
            currentPlayer.availableBurrows -= 1
        case .hare:
            currentPlayer.availableHares -= 1
        case .moon:
            currentPlayer.availableMoons -= 1
        case .rabbit:
            currentPlayer.availableRabbits -= 1
        case .field:
            currentPlayer.availableFields -= 1
        case .empress:
            break
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
    
    public func placeFieldsForDebugging() {
        for x in 2...16 {
            for y in 6...8 {
                board.placePiece(Piece(.white, .field), at: .init(x, y))
            }
            for y in 9...11 {
                board.placePiece(Piece(.blue, .field), at: .init(x, y))
            }
        }
        board.placePiece(Piece(.blue, .empress), at: .init(9, 12))
        board.placePiece(Piece(.white, .empress), at: .init(9, 5))
        
        board.removePiece(at: .init(3, 10))
        board.placePiece(Piece(.blue, .burrow), at: .init(3, 10))
        
        board.removePiece(at: .init(8, 10))
        board.placePiece(Piece(.blue, .burrow), at: .init(8, 10))
        
        board.removePiece(at: .init(13, 10))
        board.placePiece(Piece(.blue, .burrow), at: .init(13, 10))
        
        currentTurnNumber = 45
        bluePlayer.availableFields = GameConstants.initialFields - 42
        whitePlayer.availableFields = GameConstants.initialFields - 45
    }
    
    public func allAvailableMoves() -> Set<Move> {
        var set = Set<Move>()
        for placeablePiece in allPlaceablePieces() {
            set.formUnion(PlacePieceMoveGenerator.generateMoves(forPlacing: placeablePiece.type, game: self))
        }
        for empressPosition in board.piecesPositions[Piece(currentTurn, .empress)] ?? [] {
            set.formUnion(EmpressMoveGenerator.generateMoves(fromStartingPosition: empressPosition, game: self))
        }
        for harePosition in board.piecesPositions[Piece(currentTurn, .hare)] ?? [] {
            set.formUnion(HareMoveGenerator.generateMoves(fromStartingPosition: harePosition, game: self))
        }
        for rabbitPosition in board.piecesPositions[Piece(currentTurn, .rabbit)] ?? [] {
            set.formUnion(RabbitMoveGenerator.generateMoves(fromStartingPosition: rabbitPosition, game: self))
        }
        for moonPosition in board.piecesPositions[Piece(currentTurn, .moon)] ?? [] {
            set.formUnion(MoonMoveGenerator.generateMoves(fromStartingPosition: moonPosition, game: self))
        }
        return set
    }
    
    private func hasAnyMoves() -> Bool {
        if allPlaceablePieces().contains(where: { PlacePieceMoveGenerator.canPlacePiece($0.type, game: self) }) {
            return true
        }
        let empressPositions = board.piecesPositions[Piece(currentTurn, .empress)] ?? []
        if empressPositions.contains(where: { EmpressMoveGenerator.canMove(fromStartingPosition: $0, game: self) }) {
            return true
        }
        let harePositions = board.piecesPositions[Piece(currentTurn, .hare)] ?? []
        if harePositions.contains(where: { HareMoveGenerator.canMove(fromStartingPosition: $0, game: self) }) {
            return true
        }
        let rabbitPositions = board.piecesPositions[Piece(currentTurn, .rabbit)] ?? []
        if rabbitPositions.contains(where: { RabbitMoveGenerator.canMove(fromStartingPosition: $0, game: self) }) {
            return true
        }
        let moonPositions = board.piecesPositions[Piece(currentTurn, .moon)] ?? []
        if moonPositions.contains(where: { MoonMoveGenerator.canMove(fromStartingPosition: $0, game: self) }) {
            return true
        }
        return false
    }
}
