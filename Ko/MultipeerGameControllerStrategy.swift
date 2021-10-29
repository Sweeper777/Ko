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
        
    }
    
    func didEndAnimatingMoveResult(_ moveResult: MoveResult) {
        
    }
    
    func makeMenuButtons() -> [UIView]? {
        nil
    }
    
    func willMove(_ move: Move) {
        
    }
}

extension MultipeerGameControllerStrategy: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let startInfo = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? StartInfo {
            self.turns = startInfo.turns
            print(self.turns!)
        } else {
            // TODO: handle moves
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
