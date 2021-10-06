import XCTest
@testable import KoModel

class HareTests : XCTestCase {
    var game: Game!
    
    func testReachableByHare() {
        var moveResult = MoveResult()
        let rule = HareMovementRule()
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(10, 7)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(11, 7)), pendingMoveResult: &moveResult),
                       .violation)
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(0, 0)), pendingMoveResult: &moveResult),
                       .violation)
        game.board.placePiece(Piece(.blue, .empress), at: .init(10, 8))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(10, 7)), pendingMoveResult: &moveResult),
                       .compliance)
        game.board.removePiece(at: .init(9, 8))
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 8))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 7)), pendingMoveResult: &moveResult),
                       .violation)
        game.board.removePiece(at: .init(9, 8))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 7)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 8)), pendingMoveResult: &moveResult),
                       .compliance)
    }
    
    override func setUp() {
        game = Game()
        game.board.placePiece(.init(.blue, .hare), at: .init(9, 9))
        game.board.placePiece(.init(.white, .field), at: .init(10, 9))
        game.board.placePiece(.init(.white, .field), at: .init(11, 9))
        game.board.placePiece(.init(.white, .field), at: .init(12, 9))
        game.board.placePiece(.init(.white, .field), at: .init(8, 9))
        game.board.placePiece(.init(.white, .field), at: .init(7, 9))
        game.board.placePiece(.init(.white, .field), at: .init(6, 9))
        game.board.placePiece(.init(.white, .field), at: .init(9, 10))
        game.board.placePiece(.init(.white, .field), at: .init(9, 11))
        game.board.placePiece(.init(.white, .field), at: .init(9, 12))
        game.board.placePiece(.init(.white, .field), at: .init(9, 8))
        game.board.placePiece(.init(.white, .field), at: .init(9, 7))
        game.board.placePiece(.init(.white, .field), at: .init(9, 6))
    }
    
}
