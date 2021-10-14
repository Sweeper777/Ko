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
struct PositionScore : Comparable {
    let magnitude: Int
    let depth: Int

    static func <(lhs: PositionScore, rhs: PositionScore) -> Bool {
        (lhs.magnitude < rhs.magnitude) ||
                (lhs.magnitude == rhs.magnitude && lhs.depth > rhs.depth)
    }
}
