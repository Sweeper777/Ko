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
