import XCTest
@testable import KoModel

class EmpressTests: XCTestCase {
    var game: Game!
    
    override func setUp() {
        game = Game()
        game.currentTurnNumber = 5
        game.board.placePiece(Piece(.blue, .field), at: .init(8, 9))
        game.board.placePiece(Piece(.blue, .field), at: .init(9, 9))
        game.board.placePiece(Piece(.blue, .field), at: .init(10, 9))
        game.board.placePiece(Piece(.blue, .field), at: .init(8, 10))
        game.board.placePiece(Piece(.blue, .field), at: .init(9, 10))
        game.board.placePiece(Piece(.blue, .field), at: .init(10, 10))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(9, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 7))
        game.board.placePiece(Piece(.white, .field), at: .init(9, 7))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 7))
        
        game.board.placePiece(Piece(.white, .empress), at: .init(7, 8))
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 11))
        
        game.bluePlayer.availableFields -= 6
        game.whitePlayer.availableFields -= 6
    }
    
}
