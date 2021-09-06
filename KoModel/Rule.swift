enum RuleApplicationResult {
    case compliance, violation
}

protocol RuleProtocol {
    func isApplicable(to game: Game, move: Move) -> Bool
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult
}

class Rule : RuleProtocol {
    
    private let isApplicableFunc: (Game, Move) -> Bool
    private let applyFunc: (Game, Move, inout MoveResult) -> RuleApplicationResult
    
    init(isApplicable: @escaping (Game, Move) -> Bool, apply: @escaping (Game, Move, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        isApplicableFunc(game, move)
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        applyFunc(game, move, &pendingMoveResult)
    }
}

