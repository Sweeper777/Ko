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

    func evaluateHeuristics() -> Int {
    }

    private func minimax() -> Move {
        minimax(depth: searchDepth, color: myColor, alpha: PositionScore(magnitude: .min, depth: searchDepth), beta: PositionScore(magnitude: .max, depth: searchDepth)).move
    }

    private func minimax(depth: Int, color: PlayerColor, alpha: PositionScore, beta: PositionScore) -> (score: PositionScore, move: Move) {
        var score = PositionScore(magnitude: 0, depth: 0)
        var bestMove: Move?
        if game.result != .notDetermined || depth == 0 {
            score = PositionScore(magnitude: evaluateHeuristics(), depth: depth)
            return (score, bestMove ?? .move(from: .init(0, 0), to: .init(0, 0)))
        } else {
            var alphaCopy = alpha
            var betaCopy = beta
            let allMoves = game.allAvailableMoves().shuffled()
            if allMoves.count == 1, let single = allMoves.first {
                return (PositionScore(magnitude: evaluateHeuristics(), depth: depth), single)
            }
            for move in allMoves {
                let gameCopy = Game(copyOf: game)
                _ = gameCopy.makeMoveUnchecked(move)
                gameStates.append(gameCopy)
                if color == myColor {
                    score = minimax(depth: depth - 1, color: game.currentPlayer.color, alpha: alphaCopy, beta: betaCopy).score
                    if score > alphaCopy {
                        alphaCopy = score
                        bestMove = move
                    }
                } else {
                    score = minimax(depth: depth - 1, color: game.currentPlayer.color, alpha: alphaCopy, beta: betaCopy).score
                    if score < betaCopy {
                        betaCopy = score
                        bestMove = move
                    }
                }
                gameStates.removeLast()
                if alphaCopy >= betaCopy {
                    break
                }
            }
            return (color == myColor ? alphaCopy : betaCopy, bestMove ?? .move(from: .init(0, 0), to: .init(0, 0)))
        }
    }

    public func getNextMove(on dispatchQueue: DispatchQueue, completion: @escaping (Move) -> Void) {
        dispatchQueue.async { [weak self] in
            guard let `self` = self else { return }
            completion(self.minimax())
        }
    }

    public func getNextMove() -> Move {
        minimax()
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
