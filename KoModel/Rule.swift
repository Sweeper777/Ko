enum RuleApplicationResult {
    case compliance, violation
}

protocol RuleProtocol {
    func isApplicable(to game: Game, move: Move) -> Bool
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult
}

class Rule : RuleProtocol, CustomStringConvertible {
    
    private let isApplicableFunc: (Game, Move) -> Bool
    private let applyFunc: (Game, Move, inout MoveResult) -> RuleApplicationResult
    let description: String
    
    init(_ description: String? = nil,
         isApplicable: @escaping (Game, Move) -> Bool = { _,_ in true },
         apply: @escaping (Game, Move, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
        self.description = description ?? "some rule"
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        isApplicableFunc(game, move)
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        applyFunc(game, move, &pendingMoveResult)
    }
}

class IfViolatedApplyRule: RuleProtocol, CustomStringConvertible {
    
    private let rule1: RuleProtocol
    private let rule2: RuleProtocol
    
    fileprivate init(rule1: RuleProtocol, rule2: RuleProtocol) {
        self.rule1 = rule1
        self.rule2 = rule2
    }
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        rule1.isApplicable(to: game, move: move)
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        let rule1Result = rule1.apply(to: game, move: move, pendingMoveResult: &pendingMoveResult)
        if rule1Result == .violation {
            return rule2.apply(to: game, move: move, pendingMoveResult: &pendingMoveResult)
        } else {
            return rule1Result
        }
    }
    
    var description: String {
        "if \"\(rule1)\" is violated, apply \"\(rule2)\""
    }
}

extension RuleProtocol {
    func ifViolatedApply(_ rule: RuleProtocol) -> RuleProtocol {
        IfViolatedApplyRule(rule1: self, rule2: rule)
    }
}
