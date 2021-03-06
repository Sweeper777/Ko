import XCTest
@testable import KoModel

class GameBeginningTests: XCTestCase {


    func testValidGameBeginning() {
        let game = Game()
        var moveResult = game.makeMove(.placePiece(.field, at: .init(9, 9)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(9, 9))))
        XCTAssertEqual(game.board[.init(9, 9)].top, Piece(.blue, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(9, 8)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(9, 8))))
        XCTAssertEqual(game.board[.init(9, 8)].top, Piece(.white, .field))
        
        XCTAssertEqual(1, game.currentTurnNumber)
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(10, 9)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(10, 9))))
        XCTAssertEqual(game.board[.init(10, 9)].top, Piece(.blue, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(10, 8)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(10, 8))))
        XCTAssertEqual(game.board[.init(10, 8)].top, Piece(.white, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(11, 9)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(11, 9))))
        XCTAssertEqual(game.board[.init(11, 9)].top, Piece(.blue, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(11, 8)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(11, 8))))
        XCTAssertEqual(game.board[.init(11, 8)].top, Piece(.white, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(11, 10)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(11, 10))))
        XCTAssertEqual(game.board[.init(11, 10)].top, Piece(.blue, .field))
        
        moveResult = game.makeMove(.placePiece(.field, at: .init(11, 7)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .field, position: .init(11, 7))))
        XCTAssertEqual(game.board[.init(11, 7)].top, Piece(.white, .field))
        
        moveResult = game.makeMove(.placePiece(.empress, at: .init(11, 11)))
        
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .empress, position: .init(11, 11))))
        XCTAssertEqual(game.board[.init(11, 11)].top, Piece(.blue, .empress))
        
        moveResult = game.makeMove(.placePiece(.empress, at: .init(11, 6)))
        XCTAssertNotNil(moveResult)
        XCTAssertEqual(moveResult, MoveResult(piecePlaced: .init(pieceType: .empress, position: .init(11, 6))))
        XCTAssertEqual(game.board[.init(11, 6)].top, Piece(.white, .empress))
        
        XCTAssertEqual(game.board.piecesPositions, [
            Piece(.blue, .field): [.init(9, 9), .init(10, 9), .init(11, 9), .init(11, 10)],
            Piece(.white, .field): [.init(9, 8), .init(10, 8), .init(11, 8), .init(11, 7)],
            Piece(.blue, .empress): [.init(11, 11)],
            Piece(.white, .empress): [.init(11,6)],
        ])
    }
    
    func testInvalidGameBeginnings() {
        let game = Game()
        // try placing fields not in the center
        XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(0, 0))))
        XCTAssertEqual(game.currentTurn, .blue)
        
        // try moving a non-existent piece
        XCTAssertNil(game.makeMove(.move(from: .init(9, 9), to: .init(0, 0))))
        
        // try placing a non-field
        XCTAssertNil(game.makeMove(.placePiece(.empress, at: .init(9, 9))))
        
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(9, 9))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(10, 8))))
        
        // try placing a field on the opponent's side
        XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(9, 8))))
        
        // try placing a field that is only connected on the edge
        XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(8, 10))))
        
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(10, 9))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(9, 8))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(8, 9))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(8, 8))))
        
        // try placing a non-field again
        XCTAssertNil(game.makeMove(.placePiece(.empress, at: .init(9, 9))))
        
        for x in 7...11 {
            for y in 7...10 {
                if (x, y) == (8, 10) || (x, y) == (10, 10) {
                    continue
                }
                XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(x, y))))
            }
        }
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(10, 10))))
        XCTAssertNotNil(game.makeMove(.placePiece(.field, at: .init(10, 7))))
        
        // try placing a fifth field
        XCTAssertNil(game.makeMove(.placePiece(.field, at: .init(10, 11))))
        
        // try placing a disconnected empress
        XCTAssertNil(game.makeMove(.placePiece(.empress, at: .init(6, 9))))
        
        // try placing a empress disconnected to own pieces
        XCTAssertNil(game.makeMove(.placePiece(.empress, at: .init(8, 7))))
        
        XCTAssertNotNil(game.makeMove(.placePiece(.empress, at: .init(7, 9))))
        
        // try placing 2 empresses close together
        XCTAssertNil(game.makeMove(.placePiece(.empress, at: .init(7, 8))))
    }

}
