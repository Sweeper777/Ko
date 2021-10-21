import UIKit
import MultipeerConnectivity
import SwiftyButton
import RxSwift
import RxCocoa

class ConnectViewController: UIViewController {
    @IBOutlet var backButton: PressableButton!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var foundPeers = BehaviorRelay<[MCPeerID]>(value: [])
    let disposeBag = DisposeBag()

    let peerID = MCPeerID(displayName: UIDevice.current.name)
    lazy var browser = MCNearbyServiceBrowser(peer: peerID, serviceType: "ko\(Bundle.main.appBuild)")
    lazy var advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "ko\(Bundle.main.appBuild)")
    lazy var session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "NearbyPeerCell", bundle: nil), forCellReuseIdentifier: "cell")
        browser.delegate = self
        advertiser.delegate = self
        session.delegate = self
        
        browser.startBrowsingForPeers()
        advertiser.startAdvertisingPeer()
        
        backButton.setTitle("BACK", for: .normal)
        backButton.colors = PressableButton.ColorSet(
                button: UIColor.gray,
                shadow: UIColor.gray.darker())
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
    }
}

extension ConnectViewController : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    
}

extension ConnectViewController : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
}

extension ConnectViewController : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
}
