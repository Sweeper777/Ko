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

}
