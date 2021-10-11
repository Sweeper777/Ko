import XCTest
@testable import KoModel

class EmpressCastleTests: XCTestCase {

    var game: Game!
    
    override func setUp() {
        game = Game()
        game.currentTurn = .blue
        game.currentTurnNumber = 52
        
        for x in 2...16 {
            game.board.placePiece(Piece(.blue, .field), at: .init(x, 2))
            game.board.placePiece(Piece(.blue, .field), at: .init(x, 15))
        }
        for y in 3...14 {
            game.board.placePiece(Piece(.blue, .field), at: .init(2, y))
            game.board.placePiece(Piece(.blue, .field), at: .init(16, y))
        }
        game.board.placePiece(Piece(.blue, .field), at: .init(3, 3))
        game.board.placePiece(Piece(.blue, .field), at: .init(4, 3))
        game.board.placePiece(Piece(.blue, .burrow), at: .init(5, 3))
        game.board.placePiece(Piece(.blue, .burrow), at: .init(6, 3))
        game.board.placePiece(Piece(.blue, .burrow), at: .init(7, 3))
    }
    
}
