import XCTest
@testable import KoModel

class ExistenceRuleTests: XCTestCase {

    func testEmpressExistenceRule() {
        let game = Game()
        game.board.placePiece(Piece(.blue, .empress), at: .init(9, 9))
        game.currentTurnNumber = 10
        game.currentTurn = .white
        let ruleResolver = RuleResolver()
        ruleResolver.rules = [empressExistenceRule]
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.empress, at: .init(10, 10)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.empress, at: .init(9, 10)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.empress, at: .init(0, 0)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.empress, at: .init(7, 9)), game: game)
        )
    }
    
    func testEmpressMoonExistenceRules() {
        let game = Game()
        game.board.placePiece(Piece(.blue, .empress), at: .init(1, 1))
        game.board.placePiece(Piece(.blue, .moon), at: .init(5, 1))
        game.board.placePiece(Piece(.white, .empress), at: .init(1, 5))
        game.board.placePiece(Piece(.white, .moon), at: .init(5, 5))
        game.currentTurnNumber = 10
        game.currentTurn = .white
        let ruleResolver = RuleResolver()
        ruleResolver.rules = [empressMoonExistenceRule, moonEmpressExistenceRule, moonExistenceRule]
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(5, 2)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(6, 2)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(0, 1)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(2, 2)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(5, 6)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.moon, at: .init(1, 6)), game: game)
        )
    }
    
}
