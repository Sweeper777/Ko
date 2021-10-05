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
    
    func testBurrowExistenceRule() {
        let game = Game()
        game.board.placePiece(Piece(.blue, .burrow), at: .init(9, 9))
        game.currentTurnNumber = 10
        game.currentTurn = .white
        game.bluePlayer.placementRecords.append(.init(pieceType: .burrow, position: .init(9, 9)))
        game.whitePlayer.placementRecords.append(.init(pieceType: .burrow, position: .init(9, 9)))
        let ruleResolver = RuleResolver()
        ruleResolver.rules = [burrowExistenceRule]
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(9, 10)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(9, 11)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(9, 12)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(9, 13)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(9, 14)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(8, 13)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(7, 13)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(6, 13)), game: game)
        )
        XCTAssertNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(5, 13)), game: game)
        )
        XCTAssertNotNil(
            ruleResolver.resolve(against: .placePiece(.burrow, at: .init(4, 13)), game: game)
        )
    }
    
}
