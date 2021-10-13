public class Player: Codable {
    public let color: PlayerColor
    
    public internal(set) var availableFields = GameConstants.initialFields
    public internal(set) var availableBurrows = GameConstants.initialBurrows
    public internal(set) var availableRabbits = GameConstants.initialRabbits
    public internal(set) var availableHares = GameConstants.initialHares
    public internal(set) var availableMoons = GameConstants.initialMoons
    public internal(set) var placementRecords = [PiecePlacementRecord]()
    
    public init(color: PlayerColor) {
        self.color = color
    }
    
    public init(copyOf player: Player) {
        color = player.color
        availableBurrows = player.availableBurrows
        availableHares = player.availableHares
        availableRabbits = player.availableRabbits
        availableMoons = player.availableMoons
        availableFields = player.availableFields
        placementRecords = player.placementRecords
    }
}
