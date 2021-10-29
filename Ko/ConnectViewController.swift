import UIKit
import MultipeerConnectivity
import SwiftyButton
import RxSwift
import RxCocoa
import SCLAlertView
import KoModel

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
    
    weak var delegate: ConnectViewControllerDelegate?
    
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
        
        foundPeers.asObservable().bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) {
            row, model, cell in
            cell.backgroundColor = .clear
            cell.textLabel?.text = model.displayName
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let selectedPeer = self.foundPeers.value[indexPath.row]
            let timeout: TimeInterval = 30
            let invitationInfo = InvitationInfo(expiryDate: Date().addingTimeInterval(timeout))
            self.browser.invitePeer(selectedPeer, to: self.session, withContext: try? JSONEncoder().encode(invitationInfo), timeout: timeout)
            self.tableView.deselectRow(at: indexPath, animated: true)
            if let waitingForResponseVC = UIStoryboard.main?.instantiateViewController(identifier: "WaitingForResponseVC") {
                self.present(waitingForResponseVC, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        browser.stopBrowsingForPeers()
        advertiser.stopAdvertisingPeer()
    }
}

extension ConnectViewController : MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let expiryDate = context.flatMap { (try? JSONDecoder().decode(InvitationInfo.self, from: $0))?.expiryDate }
        let alert = SCLAlertView(appearance: .init(showCloseButton: false))
        alert.addButton("Yes") { [weak self] in
            let expired = expiryDate.map { $0 < Date() } ?? false
            if expired {
                SCLAlertView().showError("Oops!", subTitle: "The invitation has expired!")
            } else {
                invitationHandler(self != nil, self?.session)
                (self?.session).map { self?.delegate?.inviteeDidAcceptInvitation(session: $0) }
            }
        }
        alert.addButton("No") {
            invitationHandler(false, nil)
        }
        alert.showNotice("Accept Invitation?", subTitle: "\(peerID.displayName) invites you to join their game. Do you want to accept their invitation?")
    }
    
    
}

extension ConnectViewController : MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = foundPeers.value.firstIndex(of: peerID) else { return }
        var copy = foundPeers.value
        copy.remove(at: index)
        foundPeers.accept(copy)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        var copy = foundPeers.value
        copy.append(peerID)
        foundPeers.accept(copy)
    }
}

extension ConnectViewController : MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connecting {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            if state == .notConnected {
                SCLAlertView().showError(":-(", subTitle: "\(peerID.displayName) did not accept your invitation.")
            } else if state == .connected {
                let turns = PlayerColor.allCases.shuffled()
                self.delegate?.inviterWillStartGame(session: self.session, startInfo: StartInfo(turns: [
                    self.session.myPeerID: turns[0],
                    self.session.connectedPeers[0]: turns[1]
                ]))
            }
        }
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

protocol ConnectViewControllerDelegate: AnyObject {
    func inviterWillStartGame(session: MCSession, startInfo: StartInfo)
    func inviteeDidAcceptInvitation(session: MCSession)
}

extension MainMenuViewController: ConnectViewControllerDelegate {
    func inviteeDidAcceptInvitation(session: MCSession) {
        let gameVC = instantiateGameViewController(withStrategy: {
            MultipeerGameControllerStrategy(session: session, startInfo: nil, gameViewController: $0)
        })
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            gameVC.map { self?.present($0, animated: true, completion: nil) }
        })
    }
    
    func inviterWillStartGame(session: MCSession, startInfo: StartInfo) {
        let gameVC = instantiateGameViewController(withStrategy: {
            MultipeerGameControllerStrategy(session: session, startInfo: startInfo, gameViewController: $0)
        })
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            gameVC.map { self?.present($0, animated: true, completion: nil) }
        })
    }
}
