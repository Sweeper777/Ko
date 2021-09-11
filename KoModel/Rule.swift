enum RuleApplicationResult {
    case compliance, violation
}

protocol RuleProtocol: CustomStringConvertible {
    func isApplicable(to game: Game, move: Move) -> Bool
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult
}

class Rule : RuleProtocol {
    
    private let isApplicableFunc: (Game, Move) -> Bool
    private let applyFunc: (Game, Move, inout MoveResult) -> RuleApplicationResult
    private let _description: String
    
    var description: String {
        _description
    }
    
    init(_ description: String? = nil,
         isApplicable: @escaping (Game, Move) -> Bool = { _,_ in true },
         apply: @escaping (Game, Move, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
        self._description = description ?? "some rule"
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        isApplicableFunc(game, move)
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        applyFunc(game, move, &pendingMoveResult)
    }
}

class PlacePieceRule : RuleProtocol {
    private let isApplicableFunc: (Game, PiecePlacementRecord) -> Bool
    private let applyFunc: (Game, PiecePlacementRecord, inout MoveResult) -> RuleApplicationResult
    private let _description: String
    
    var description: String {
        _description
    }
    
    init(_ description: String? = nil,
         isApplicable: @escaping (Game, PiecePlacementRecord) -> Bool = { _,_ in true },
         apply: @escaping (Game, PiecePlacementRecord, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
        self._description = description ?? "some place piece rule"
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        if case .placePiece(let pieceType, let pos) = move {
            return isApplicableFunc(game, PiecePlacementRecord(pieceType: pieceType, position: pos))
        } else {
            return false
        }
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        if case .placePiece(let pieceType, let pos) = move {
            return applyFunc(game, PiecePlacementRecord(pieceType: pieceType, position: pos), &pendingMoveResult)
        } else {
            fatalError("This rule is not applicable!")
        }
    }
}

class MoveRule : RuleProtocol {
    private let isApplicableFunc: (Game, Position, Position) -> Bool
    private let applyFunc: (Game, Position, Position, inout MoveResult) -> RuleApplicationResult
    private let pieceFilter: PieceType?
    private let _description: String
    
    var description: String {
        _description
    }
    
    init(_ description: String? = nil, for pieceType: PieceType? = nil,
         isApplicable: @escaping (Game, Position, Position) -> Bool = { _,_,_ in true },
         apply: @escaping (Game, Position, Position, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
        pieceFilter = pieceType
        self._description = description ?? "some move rule"
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        if case .move(let from, let to) = move {
            if let pieceFilter = pieceFilter {
                if !(pieceFilter ~= game.board[from]) {
                    return false
                }
            }
            return isApplicableFunc(game, from, to)
        } else {
            return false
        }
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        if case .move(let from, let to) = move {
            return applyFunc(game, from, to, &pendingMoveResult)
        } else {
            fatalError("This rule is not applicable!")
        }
    }
}

class IfViolatedApplyRule: RuleProtocol {
    
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

class ExistenceRule : RuleProtocol {
    private let isApplicableFunc: (Game, Position) -> Bool
    private let applyFunc: (Game, Position, inout MoveResult) -> RuleApplicationResult
    private let _description: String
    private let pieceType: PieceType
    
    var description: String {
        _description
    }
    
    init(_ description: String? = nil,
         for pieceType: PieceType,
         isApplicable: @escaping (Game, Position) -> Bool = { _,_ in true },
         apply: @escaping (Game, Position, inout MoveResult) -> RuleApplicationResult) {
        isApplicableFunc = isApplicable
        applyFunc = apply
        self.pieceType = pieceType
        self._description = description ?? "some existence rule for \(pieceType)"
    }
    
    
    func isApplicable(to game: Game, move: Move) -> Bool {
        if case .placePiece(pieceType, let pos) = move {
            return isApplicableFunc(game, pos)
        } else if case .move(_, let to) = move {
            return isApplicableFunc(game, to)
        } else {
            return false
        }
    }
    
    func apply(to game: Game, move: Move, pendingMoveResult: inout MoveResult) -> RuleApplicationResult {
        if case .placePiece(pieceType, let pos) = move {
            return applyFunc(game, pos, &pendingMoveResult)
        } else if case .move(_, let to) = move {
            return applyFunc(game, to, &pendingMoveResult)
        } else {
            fatalError("This rule is not applicable!")
        }
    }
}
