enum RuleApplicationResult {
    case compliance, violation
}

protocol RuleProtocol {
    func isApplicable(to game: Game, move: Move) -> Bool
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult
}

