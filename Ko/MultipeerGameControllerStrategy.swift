import UIKit
import KoModel
import MultipeerConnectivity
import SCLAlertView

class MultipeerGameControllerStrategy: NSObject, GameControllerStrategy {
    
    let session: MCSession
    var turns: [MCPeerID: PlayerColor]?
    private var disconnectHandled = false
    private unowned let gameViewController: GameViewController

    init(session: MCSession, startInfo: StartInfo?, gameViewController: GameViewController) {
        self.session = session
        self.turns = startInfo?.turns
        self.gameViewController = gameViewController
        super.init()
    }
    
    func didRestartGame() {
        
    }
    
    func didEndAnimatingMoveResult(_ moveResult: MoveResult) {
        
    }
    
    func makeMenuButtons() -> [UIView]? {
        nil
    }
    
    func willMove(_ move: Move) {
        
    }
}

    
    
}
