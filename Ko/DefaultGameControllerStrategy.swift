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

    func makeMenuButtons() -> [UIView] {
        [
            MenuButtonFactory.makeCloseButton(withTarget: gameViewController, action: #selector(GameViewController.closeTapped)),
            MenuButtonFactory.makeFlipBoardButton(withTarget: gameViewController, action: #selector(GameViewController.flipBoard)),
            MenuButtonFactory.makeRestartButton(withTarget: gameViewController, action: #selector(GameViewController.restartTapped))
        ]
    }

    func willMove(_ move: Move) {

    }
}

