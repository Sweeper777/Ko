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
    
    func testTopLeftWin() {
        game.board.placePiece(Piece(.blue, .field), at: .init(0, 1))
        game.board.placePiece(Piece(.blue, .field), at: .init(1, 0))
        game.board.placePiece(Piece(.blue, .empress), at: .init(1, 1))
        game.board.placePiece(Piece(.blue, .field), at: .init(2, 1))
        game.board.placePiece(Piece(.blue, .moon), at: .init(1, 2))
        var moveResult = MoveResult(piecePlaced: .init(pieceType: .field, position: .init(0, 0)))
        let rule = EmpressCastleRule()
        XCTAssertEqual(rule.apply(to: game, move: .placePiece(.field, at: .init(0, 0)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(moveResult.gameResult, .wins(.blue))
    }
    func testTopRightWin() {
        game.board.placePiece(Piece(.blue, .field), at: .init(18, 1))
        game.board.placePiece(Piece(.blue, .field), at: .init(17, 0))
        game.board.placePiece(Piece(.blue, .empress), at: .init(17, 1))
        game.board.placePiece(Piece(.blue, .field), at: .init(16, 1))
        game.board.placePiece(Piece(.blue, .moon), at: .init(17, 2))
        var moveResult = MoveResult(piecePlaced: .init(pieceType: .field, position: .init(18, 0)))
        let rule = EmpressCastleRule()
        XCTAssertEqual(rule.apply(to: game, move: .placePiece(.field, at: .init(18, 0)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(moveResult.gameResult, .wins(.blue))
    }
    func testBottomLeftWin() {
        game.board.placePiece(Piece(.blue, .field), at: .init(0, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(1, 17))
        game.board.placePiece(Piece(.blue, .empress), at: .init(1, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(2, 16))
        game.board.placePiece(Piece(.blue, .moon), at: .init(1, 15))
        var moveResult = MoveResult(piecePlaced: .init(pieceType: .field, position: .init(0, 17)))
        let rule = EmpressCastleRule()
        XCTAssertEqual(rule.apply(to: game, move: .placePiece(.field, at: .init(0, 17)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(moveResult.gameResult, .wins(.blue))
    }
    func testBottomRightWin() {
        game.board.placePiece(Piece(.blue, .field), at: .init(18, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(17, 17))
        game.board.placePiece(Piece(.blue, .empress), at: .init(17, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(16, 16))
        game.board.placePiece(Piece(.blue, .moon), at: .init(17, 15))
        var moveResult = MoveResult(piecePlaced: .init(pieceType: .field, position: .init(18, 17)))
        let rule = EmpressCastleRule()
        XCTAssertEqual(rule.apply(to: game, move: .placePiece(.field, at: .init(18, 17)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(moveResult.gameResult, .wins(.blue))
    }
    func testNotEnoughFields() {
        game.board.removePiece(at: .init(3, 3))
        game.board.placePiece(Piece(.blue, .field), at: .init(18, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(17, 17))
        game.board.placePiece(Piece(.blue, .empress), at: .init(17, 16))
        game.board.placePiece(Piece(.blue, .field), at: .init(16, 16))
        game.board.placePiece(Piece(.blue, .moon), at: .init(17, 15))
        var moveResult = MoveResult(piecePlaced: .init(pieceType: .field, position: .init(18, 17)))
        let rule = EmpressCastleRule()
        XCTAssertEqual(rule.apply(to: game, move: .placePiece(.field, at: .init(18, 17)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(moveResult.gameResult, .notDetermined)
    }
}
