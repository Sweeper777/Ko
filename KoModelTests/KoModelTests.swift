import XCTest
import KoModel

class PerformanceTest: XCTestCase {

    func testPerformance() throws {
        let game = Game()
        game.placeFieldsForDebugging()
        _ = game.makeMove(.move(from: .init(9, 12), to: .init(10, 12)))
        _ = game.makeMove(.placePiece(.rabbit, at: .init(8, 5)))
        _ = game.makeMove(.move(from: .init(10, 12), to: .init(9, 12)))
        _ = game.makeMove(.placePiece(.hare, at: .init(9, 5)))
        _ = game.makeMove(.move(from: .init(9, 12), to: .init(10, 12)))
        _ = game.makeMove(.placePiece(.moon, at: .init(9, 4)))
        _ = game.makeMove(.move(from: .init(10, 12), to: .init(9, 12)))
        self.measure {
            _ = game.allAvailableMoves()
        }
    }

}
