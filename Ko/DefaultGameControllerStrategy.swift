import UIKit
import KoModel
class DefaultGameControllerStrategy : GameControllerStrategy {
    private unowned var gameViewController: GameViewController

    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    func didRestartGame() {

    }

    func didEndAnimatingMoveResult(_ moveResult: MoveResult) {
        
        gameViewController.pieceSelector.selectablePieces =
            gameViewController.game.allPlaceablePieces()
    }

    func makeMenuButtons() -> [UIView]? {
        nil
    }

    func willMove(_ move: Move) {

    }

}

