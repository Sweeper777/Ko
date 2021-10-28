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

    func encode(with coder: NSCoder) {
        coder.encode(turns.mapValues(\.rawValue), forKey: Keys.turns.stringValue)
    }

    convenience init?(coder: NSCoder) {
        guard let turns = coder.decodeObject(of: NSDictionary.self, forKey: Keys.turns.stringValue) as? [MCPeerID: Int] else {
            return nil
        }
        self.init(turns: turns.mapValues { PlayerColor(rawValue: $0)! })
    }

    override var description: String {
        "StartInfo(turns: \(turns))"
    }
}
