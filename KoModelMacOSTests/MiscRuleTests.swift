import XCTest
@testable import KoModel

class MiscRuleTests: XCTestCase {

    func testNoMoveToSameSquareRule() {
        let game = Game()
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 9))
        game.currentTurnNumber = 10
        game.currentTurn = .blue
        let ruleResolver = RuleResolver()
        ruleResolver.rules = [noMoveToSameSquareRule]
        XCTAssertNil(
            ruleResolver.resolve(against: .move(from: .init(9, 9), to: .init(9, 9)), game: game)
        )
    }

    func testStalemateRule() {
        let game = Game()
        game.board.placePiece(Piece(.white, .field), at: .init(8, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(9, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 8))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 7))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 7))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 6))
        game.board.placePiece(Piece(.white, .empress), at: .init(9, 6))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 6))
        game.board.placePiece(Piece(.white, .field), at: .init(8, 5))
        game.board.placePiece(Piece(.white, .field), at: .init(9, 5))
        game.board.placePiece(Piece(.white, .field), at: .init(10, 5))
        for y in 0...13 {
            game.board.placePiece(Piece(.blue, .field), at: .init(11, y))
        }
        game.board.placePiece(Piece(.blue, .hare), at: .init(7, 7))
        game.currentTurn = .blue
        game.currentTurnNumber = 20
        _ = game.makeMove(.move(from: .init(7, 7), to: .init(9, 7)))
        XCTAssertEqual(game.result, .draw)
    }
}
