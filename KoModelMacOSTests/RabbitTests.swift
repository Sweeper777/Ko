import XCTest
@testable import KoModel

class RabbitTests: XCTestCase {

    var game: Game!
    
    override func setUp() {
        game = Game()
        game.currentTurn = .blue
        game.currentTurnNumber = 10
        for x in 8...10 {
            for y in 8...10 {
                game.board.placePiece(Piece(.white, .field), at: .init(x, y))
            }
        }
    }
    
}
