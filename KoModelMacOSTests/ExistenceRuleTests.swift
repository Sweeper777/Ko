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
    
}
