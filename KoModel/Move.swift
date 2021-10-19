public enum Move: Hashable, Codable {
    case placePiece(PieceType, at: Position)
    case move(from: Position, to: Position)
}

public enum GameResult: Hashable {
    case notDetermined, wins(PlayerColor), draw
}

public struct MoveResult: Hashable {
    public var gameResult: GameResult
    public var piecePlaced: PiecePlacementRecord?
    public var piecesRemoved: [PieceRemovalRecord]
    public var conqueredPositions: [Position]
    public var hasCapture: Bool
    public var fromPosition: Position?
    public var toPosition: Position?
    
    public init(gameResult: GameResult = .notDetermined,
                piecePlaced: PiecePlacementRecord? = nil,
                piecesRemoved: [PieceRemovalRecord] = [],
                conqueredPositions: [Position] = [],
                hasCapture: Bool = false,
                fromPosition: Position? = nil,
                toPosition: Position? = nil) {
        self.gameResult = gameResult
        self.piecePlaced = piecePlaced
        self.piecesRemoved = piecesRemoved
        self.conqueredPositions = conqueredPositions
        self.hasCapture = hasCapture
        self.fromPosition = fromPosition
        self.toPosition = toPosition
    }
}

extension Move {
    enum CodingKeys: CodingKey {
        case pieceType
        case source
        case destination
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let pieceType = try container.decodeIfPresent(PieceType.self, forKey: .pieceType) {
            let destination = try container.decode(Position.self, forKey: .destination)
            self = .placePiece(pieceType, at: destination)
        } else {
            self = .move(from: try container.decode(Position.self, forKey: .source),
                         to: try container.decode(Position.self, forKey: .destination))
        }
    }
    
}
