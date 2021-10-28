import MultipeerConnectivity
import KoModel
struct InvitationInfo: Codable {
    let expiryDate: Date
}


final class StartInfo : NSObject, NSCoding {
    let turns: [MCPeerID: PlayerColor]

    enum Keys: CodingKey {
        case turns
    }

    init(turns: [MCPeerID: PlayerColor]) {
        self.turns = turns
    }

    override var description: String {
        "StartInfo(turns: \(turns))"
    }
}
