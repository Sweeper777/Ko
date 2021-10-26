import UIKit
import KoModel

protocol GameControllerStrategy {
    func didRestartGame()
    func didEndAnimatingMoveResult(_ moveResult: MoveResult)
    func makeMenuButtons() -> [UIView]?
    func willMove(_ move: Move)
}
