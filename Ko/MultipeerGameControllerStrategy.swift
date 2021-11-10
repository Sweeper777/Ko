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
        session.delegate = self
        if let startInfo = startInfo {
            let startData = try! NSKeyedArchiver.archivedData(
                withRootObject: startInfo, requiringSecureCoding: false)
            try! session.send(startData,
                              toPeers: session.connectedPeers, with: .reliable)
        }
    }
    
    func didRestartGame() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(kCircleIconHeight: 56, showCloseButton: false))
        alert.addButton("OK", action: {})
        let myColor = (turns ?? [:])[session.myPeerID]
        _ = alert.showCustom(
                String(format: "Your color is %@.", myColor?.description ?? "Unknown"),
                subTitle: "", color: .black,
            icon: ((myColor?.uiColor) ?? .black).image(size: CGSize(width: 56, height: 56)))
        if gameViewController.game.currentTurn == (turns ?? [:])[session.myPeerID] { // white device
            gameViewController.setUserInteractionEnabled(true)
        } else { // blue device
            gameViewController.setUserInteractionEnabled(false)
            gameViewController.pieceSelector.selectablePieces = []
            gameViewController.flipBoard()
        }
    }
    
    func didEndAnimatingMoveResult(_ moveResult: MoveResult) {
        if gameViewController.game.currentTurn == (turns ?? [:])[session.myPeerID] {
            gameViewController.setUserInteractionEnabled(true)
            gameViewController.pieceSelector.selectablePieces = gameViewController.game.allPlaceablePieces()
        } else {
            gameViewController.setUserInteractionEnabled(false)
        }
    }
    
    func makeMenuButtons() -> [UIView] {
        [
            MenuButtonFactory.makeCloseButton(withTarget: self, action: #selector(closeTapped)),
            MenuButtonFactory.makeFlipBoardButton(withTarget: gameViewController, action: #selector(GameViewController.flipBoard)),
        ]
    }
    
    func willMove(_ move: Move) {
        if let data = try? JSONEncoder().encode(move) {
            try! session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } else {
            SCLAlertView().showError("Error", subTitle: "An error occurred while sending your move to the opponent.")
        }
    }
    
    @objc func closeTapped() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("Yes", action: {
            [weak self] in
            guard let `self` = self else { return }
            self.disconnectHandled = true
            self.gameViewController.quitGame()
            self.session.disconnect()
        })
        alert.addButton("No", action: {})
        alert.showWarning("Confirm", subTitle: "Do you really want to quit?")
    }
}

extension MultipeerGameControllerStrategy: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        guard state == .notConnected else { return }

        if session.connectedPeers.isEmpty && !disconnectHandled {
            disconnectHandled = true
            DispatchQueue.main.async { [weak self] in
                let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                alert.addButton("OK", action: {
                    [weak self] in
                    self?.gameViewController.dismiss(animated: true, completion: nil)
                })
                _ = alert.showWarning("Game Over", subTitle: "You disconnected from the game.")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let startInfo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? StartInfo {
            self.turns = startInfo.turns
        } else if let move = try? JSONDecoder().decode(Move.self, from: data) {
            DispatchQueue.main.async { [weak self] in
                if let moveResult = self?.gameViewController.game.makeMove(move) {
                    self?.gameViewController.boardView.animateMoveResult(moveResult)
                    self?.gameViewController.updateViews()
                } else {
                    SCLAlertView().showError("Error", subTitle: "The move your opponent made was invalid!")
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}

private extension PlayerColor {
    var uiColor: UIColor {
        switch self {
        case .blue:
            return UIColor(named: "bluePlayerColor")!
        case .white:
            return UIColor(named: "whitePlayerColor")!
        }
    }
}
