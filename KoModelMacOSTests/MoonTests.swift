import XCTest
@testable import KoModel

class MoonTests: XCTestCase {

    var game: Game!
    
    let fieldPositions = [
        Position(9, 8), Position(10, 8),
        Position(8, 9), Position(11, 9),
        Position(8, 10), Position(11, 10),
        Position(9, 11), Position(10, 11)
    ]
    
    
    override func setUp() {
        game = Game()
        game.currentTurn = .blue
        game.currentTurnNumber = 10
        for pos in fieldPositions {
            game.board.placePiece(Piece(.blue, .field), at: pos)
        }
        game.board.placePiece(Piece(.blue, .moon), at: .init(9, 9))
    }
}
