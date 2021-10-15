import XCTest
@testable import KoModel

class RabbitTests: XCTestCase {

    var game: Game!
    
    override func setUp() {
        game = Game()
        game.currentTurn = .blue
        game.currentTurnNumber = 10
        for x in 8...10 {
            for y in 8...10 {
                game.board.placePiece(Piece(.white, .field), at: .init(x, y))
            }
        }
    }
    
    func testRabbitJumps() {
        game.board.placePiece(Piece(.blue, .rabbit), at: .init(7, 10))
        let rule = rabbitMoveRule
        var moveResult = MoveResult()
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(7, 10), to: .init(11, 10)), pendingMoveResult: &moveResult),
                       .compliance)
        
        game.board.removePiece(at: .init(7, 10))
        game.board.placePiece(Piece(.blue, .rabbit), at: .init(8, 11))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(8, 11), to: .init(8, 7)), pendingMoveResult: &moveResult),
                       .compliance)
        
        game.board.removePiece(at: .init(8, 11))
        game.board.placePiece(Piece(.blue, .rabbit), at: .init(7, 7))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(7, 7), to: .init(11, 11)), pendingMoveResult: &moveResult),
                       .compliance)
    }
    
    func testRabbitConquer() {
        let rule = rabbitMoveRule
        var moveResult = MoveResult()
        game.board.placePiece(Piece(.blue, .rabbit), at: .init(7, 7))
        XCTAssertEqual(rule.apply(to: game, move: .move(from: .init(7, 7), to: .init(11, 11)), pendingMoveResult: &moveResult),
                       .compliance)
        XCTAssertEqual(Set(moveResult.conqueredPositions), [.init(8, 8), .init(9, 9), .init(10, 10)])
    }
}
