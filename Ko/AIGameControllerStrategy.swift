import UIKit
import KoModel
import SCLAlertView

class AIGameControllerStrategy : GameControllerStrategy {
    private unowned var gameViewController: GameViewController
    var humanPlayerColor: PlayerColor
    var currentAI: GameAI?

    init(gameViewController: GameViewController, humanPlayerColor: PlayerColor) {
        self.gameViewController = gameViewController
        self.humanPlayerColor = humanPlayerColor
    }
    
    func didRestartGame() {
        tryAIMove()
    }

    func didEndAnimatingMoveResult(_ moveResult: MoveResult) {
        tryAIMove()
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

    var isAITurn: Bool {
        gameViewController.game.currentTurn != humanPlayerColor
    }
    
    func tryAIMove() {
        guard isAITurn else {
            gameViewController.setUserInteractionEnabled(true)
            gameViewController.pieceSelector.selectablePieces = gameViewController.game.allPlaceablePieces()
            return
        }
        gameViewController.setUserInteractionEnabled(false)
        guard case .notDetermined = gameViewController.game.result else {
            return
        }
        
        currentAI = GameAI(game: gameViewController.game, myColor: gameViewController.game.currentTurn)
        currentAI?.getNextMove(on: .global(qos: .userInitiated)) { [weak self] aiMove in
            DispatchQueue.main.async { [weak self] in
                guard let moveResult = self?.gameViewController.game.makeMoveUnchecked(aiMove) else {
                    return
                }
                self?.gameViewController.updateViews()
                self?.gameViewController.boardView.animateMoveResult(moveResult)
            }
        }
    }
}

