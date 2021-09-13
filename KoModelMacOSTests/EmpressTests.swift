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
    
    func testMovement() {
        // moving opponent's piece
        XCTAssertNil(game.makeMove(.move(from: .init(7, 8), to: .init(7, 9))))
        // moving empress onto a field
        XCTAssertNil(game.makeMove(.move(from: .init(9, 11), to: .init(9, 10))))
        // disconnecting the grassland
        XCTAssertNil(game.makeMove(.move(from: .init(9, 11), to: .init(9, 12))))
        
        XCTAssertEqual(game.board.piecesPositions[Piece(.blue, .empress)], [.init(9, 11)])
        XCTAssertEqual(game.board.piecesPositions[Piece(.white, .empress)], [.init(7, 8)])
        
        var moveResult = game.makeMove(.move(from: .init(9, 11), to: .init(10, 11)))
        XCTAssertEqual(moveResult, MoveResult(fromPosition: .init(9, 11), toPosition: .init(10, 11)))
        
        moveResult = game.makeMove(.move(from: .init(7, 8), to: .init(7, 9)))
        XCTAssertEqual(moveResult, MoveResult(fromPosition: .init(7, 8), toPosition: .init(7, 9)))
        
        moveResult = game.makeMove(.move(from: .init(10, 11), to: .init(11, 10)))
        XCTAssertEqual(moveResult, MoveResult(fromPosition: .init(10, 11), toPosition: .init(11, 10)))
        
        moveResult = game.makeMove(.move(from: .init(7, 9), to: .init(7, 10)))
        XCTAssertEqual(moveResult, MoveResult(fromPosition: .init(7, 9), toPosition: .init(7, 10)))
        
        XCTAssertEqual(game.board.piecesPositions[Piece(.blue, .empress)], [.init(11, 10)])
        XCTAssertEqual(game.board.piecesPositions[Piece(.white, .empress)], [.init(7, 10)])
    }
    
}
