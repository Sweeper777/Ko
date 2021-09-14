import XCTest
@testable import KoModel

class HareTests : XCTestCase {
    func testReachableByHare() {
        let game = Game()
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
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 8))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 7)), pendingMoveResult: &moveResult),
                       .violation)
        game.board.removePiece(at: .init(9, 8))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 7)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: .init(9, 8)), pendingMoveResult: &moveResult),
                       .compliance)
    }
}
