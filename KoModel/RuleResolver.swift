class RuleResolver {
    var rules: [RuleProtocol] = []
    var outputDebugMessages = false
    func resolve(against move: Move, game: Game) -> MoveResult? {
        var moveResult = MoveResult()
        var hasApplicableRules = false
        for rule in rules {
            if rule.isApplicable(to: game, move: move) {
                hasApplicableRules = true
                let ruleApplicationResult = rule.apply(to: game, move: move, pendingMoveResult: &moveResult)
                if ruleApplicationResult == .violation {
                    if outputDebugMessages {
                        print("Rule violated: \(rule)")
                    }
                    return nil
                }
            }
        }
        guard hasApplicableRules else {
            return nil
        }
        return moveResult
    }
}
