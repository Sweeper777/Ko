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
}
