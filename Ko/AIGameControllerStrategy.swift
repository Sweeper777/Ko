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

    func makeMenuButtons() -> [UIView]? {
        nil
    }

    func willMove(_ move: Move) {

    }

    var isAITurn: Bool {
        gameViewController.game.currentTurn != humanPlayerColor
    }
    
    func tryAIMove() {
        guard isAITurn else {
            gameViewController.setUserInteractionEnabled(true)
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
                self?.gameViewController.boardView.animateMoveResult(moveResult) { [weak self] in
                    self?.gameViewController.setUserInteractionEnabled(true)
                    if case .wins(let color) = self?.gameViewController.game.result {
                        SCLAlertView().showInfo("Game Over!", subTitle: "\(color) wins!")
                    } else if .draw == self?.gameViewController.game.result {
                        SCLAlertView().showInfo("Game Over!", subTitle: "It's a draw!")
                    }
                }
            }
        }
    }
}

