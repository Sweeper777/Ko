public class Game {
    public let bluePlayer = Player(color: .blue)
    public let whitePlayer = Player(color: .white)
    public private(set) var currentTurn = PlayerColor.blue
    public private(set) var board = Board()
    public private(set) var currentTurnNumber = 0
    
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
    
        }
    }
    
    
}
