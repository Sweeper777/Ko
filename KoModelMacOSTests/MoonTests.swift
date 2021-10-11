import XCTest
@testable import KoModel

class MoonTests: XCTestCase {

    var game: Game!
    
    let fieldPositions = [
        Position(9, 8), Position(10, 8),
        Position(8, 9), Position(11, 9),
        Position(8, 10), Position(11, 10),
        Position(9, 11), Position(10, 11)
    ]
    
    func testReachableByMoon() {
        var moveResult = MoveResult()
        let rule = MoonMovementRule()
        let reachablePositions = [
            Position(10, 9),
            Position(10, 10),
            Position(9, 10),
        ]
        for pos in reachablePositions {
            XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: pos), pendingMoveResult: &moveResult),
                       .compliance)
        }
    }
    
    func testUnreachableByMoon() {
        var moveResult = MoveResult()
        let rule = MoonMovementRule()
        let unreachablePositions = [
            Position(8, 8),
            Position(11, 8),
            Position(8, 11),
            Position(11, 11),
            Position(9, 7),
            Position(10, 7),
            Position(9, 12),
            Position(10, 12),
            Position(7, 9),
            Position(7, 10),
            Position(12, 9),
            Position(12, 10),
        ]
        for pos in unreachablePositions {
            XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(9, 9), to: pos), pendingMoveResult: &moveResult),
                       .violation)
        }
    }
    
    func testCaptures() {
        let movementRule = MoonMovementRule()
        let captureRule = MoonCaptureRule()
        for pos in fieldPositions {
            var moveResult = MoveResult()
            XCTAssertEqual(movementRule.apply(to: game, move: .move(from: .init(9, 9), to: pos), pendingMoveResult: &moveResult),
                       .compliance)
            XCTAssertEqual(captureRule.apply(to: game, move: .move(from: .init(9, 9), to: pos), pendingMoveResult: &moveResult),
                       .compliance)
            XCTAssertTrue(moveResult.hasCapture)
        }
    }
    
    override func setUp() {
        game = Game()
        game.currentTurn = .blue
        game.currentTurnNumber = 10
        for pos in fieldPositions {
            game.board.placePiece(Piece(.blue, .field), at: pos)
        }
        game.board.placePiece(Piece(.blue, .moon), at: .init(9, 9))
    }
}
