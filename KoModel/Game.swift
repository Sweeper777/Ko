public class Game {
    public let bluePlayer = Player(color: .blue)
    public let whitePlayer = Player(color: .white)
    public private(set) var currentTurn = PlayerColor.blue
    public private(set) var board = Board()
    public private(set) var currentTurnNumber = 0
    
    public var currentPlayer: Player {
        switch currentTurn {
        case .white: return whitePlayer
        case .blue: return bluePlayer
        }
    }
    
    public var currentOpponent: Player {
        switch currentTurn {
        case .white: return bluePlayer
        case .blue: return whitePlayer
        }
    }
    
    
}
