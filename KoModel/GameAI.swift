import Foundation

public class GameAI {
    var gameStates: [Game]
    var game: Game {
        gameStates.last!
    }
    
    let myColor: PlayerColor
    let searchDepth = 6

    public init(game: Game, myColor: PlayerColor) {
        self.gameStates = [game]
        self.myColor = myColor
    }

}
