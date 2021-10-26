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
    

    var isAITurn: Bool {
        gameViewController.game.currentTurn != humanPlayerColor
    }
    
}

