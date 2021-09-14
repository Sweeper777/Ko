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
    
    func testEmpressesThatAreTooClose() {
        XCTAssertNotNil(game.makeMove(.move(from: .init(9, 11), to: .init(8, 11))))
        XCTAssertNotNil(game.makeMove(.move(from: .init(7, 8), to: .init(7, 9))))
        XCTAssertNil(game.makeMove(.move(from: .init(8, 11), to: .init(7, 10))))
        XCTAssertNotNil(game.makeMove(.move(from: .init(8, 11), to: .init(7, 11))))
        XCTAssertEqual(game.board.piecesPositions[Piece(.blue, .empress)], [.init(7, 11)])
        XCTAssertEqual(game.board.piecesPositions[Piece(.white, .empress)], [.init(7, 9)])
    }
    
    func testPlacingPieces() {
        // placing fields out of range
        XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(9, 13))))
        
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(9, 12))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(6, 8))))
        
        // cannot place piece when there are not enough fields
        XCTAssertNil(game.makeMove(.placePiece(.burrow, at: .init(10, 11))))
        XCTAssertNil(game.makeMove(.placePiece(.hare, at: .init(10, 11))))
        XCTAssertNil(game.makeMove(.placePiece(.moon, at: .init(10, 11))))
        XCTAssertNil(game.makeMove(.placePiece(.rabbit, at: .init(10, 11))))
    }
    
    func testPlacingBurrows() {
        game.board.removePiece(at: .init(9, 10))
        game.board.removePiece(at: .init(9, 11))
        game.board.placePiece(Piece(.blue, .field), at: .init(9, 11))
        game.board.placePiece(Piece(.blue, .field), at: .init(8, 11))
        game.board.placePiece(Piece(.blue, .field), at: .init(10, 11))
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 12))
        game.board.removePiece(at: .init(9, 7))
        game.board.placePiece(Piece(.white, .field), at: .init(9, 6))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 6))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 6))
        game.bluePlayer.availableFields -= 2
        game.whitePlayer.availableFields -= 2
        
        // try placing burrow somewhere random
        XCTAssertNil(game.makeMove(.placePiece(.burrow, at: .init(10, 12))))
        XCTAssertNil(game.makeMove(.placePiece(.burrow, at: .init(11, 12))))
        
        XCTAssertNotNil(game.makeMove(.placePiece(.burrow, at: .init(9, 10))))
        XCTAssertNotNil(game.makeMove(.placePiece(.burrow, at: .init(9, 7))))
        XCTAssertEqual(game.bluePlayer.placementRecords, [.init(pieceType: .burrow, position: .init(9, 10))])
        XCTAssertEqual(game.whitePlayer.placementRecords, [.init(pieceType: .burrow, position: .init(9, 7))])
    }
}
