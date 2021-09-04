public struct Board {
    public private(set) var board = Array2D<PieceStack>(
        columns: GameConstants.boardColumns, rows: GameConstants.boardRows, initialValue: .init()
    )
    
    public private(set) var piecesPositions: [Piece: Set<Position>] = [:]
    
    public subscript(_ x: Int, _ y: Int) -> PieceStack {
        board[x, y]
    }
    
    public subscript(_ position: Position) -> PieceStack {
        board[position]
    }
    
    func isValidPosition(for piece: Piece, position: Position) -> Bool {
        if board[safe: position] == nil {
            return false
        }
        
        func isValidPositionForHare() -> Bool {
            board[position].isEmpty || .field ~= board[position] ||
                .rabbit ~= board[position] || .hare ~= board[position]
        }
        
        func isValidPositionForEmpress() -> Bool {
            guard board[position].isEmpty else {
                return false
            }
            
            let opposingMoon = Piece(piece.color.opposingColor, .moon)
            let opposingEmpress = Piece(piece.color.opposingColor, .empress)
            return (piecesPositions[opposingMoon] ?? []).intersection([
                position.above(), position.below(), position.left(), position.right()
            ]).isEmpty &&
                (piecesPositions[opposingEmpress] ?? []).intersection([
                    position.above(), position.below(), position.left(), position.right(),
                    position.above().left(), position.above().right(),
                    position.below().left(), position.below().right()
                ]).isEmpty
        }
        func isValidPositionForBurrow() -> Bool {
            guard board[position].isEmpty else {
                return false
            }
            let eightNeighbours = [
                position.above(), position.below(), position.left(), position.right(),
                position.above().left(), position.above().right(),
                position.below().left(), position.below().right()
            ]
            let isSurroundedByFields = (piecesPositions[Piece(.blue, .field)] ?? []).union(piecesPositions[Piece(.white, .field)] ?? [])
                .isSuperset(of: eightNeighbours)
            let is4BlocksAwayFromAllBurrows = (piecesPositions[Piece(.blue, .burrow)] ?? []).union(piecesPositions[Piece(.white, .burrow)] ?? [])
                .allSatisfy { abs(position.x - $0.x) >= 5 && abs(position.y - $0.y) >= 5 }
            return isSurroundedByFields && is4BlocksAwayFromAllBurrows
        }
        func isValidPositionForMoon() -> Bool {
            guard board[position].isEmpty else {
                return false
            }
            let opposingMoon = Piece(piece.color.opposingColor, .moon)
            return (piecesPositions[opposingMoon] ?? []).intersection([
                position.above(), position.below(), position.left(), position.right(),
                position.above().left(), position.above().right(),
                position.below().left(), position.below().right()
            ]).isEmpty
        }
        
        switch piece.type {
        case .field, .rabbit:
            return board[position].isEmpty
        case .hare:
            return isValidPositionForHare()
        case .empress:
            return isValidPositionForEmpress()
        case .moon:
            return isValidPositionForMoon()
        case .burrow:
            return isValidPositionForBurrow()
        }
    }
    
    func isExactlyOneGrassland(startPosition start: Position) -> Bool {
        var unreached = piecesPositions.values.reduce(Set()) { $0.union($1) }
        unreached.remove(start)
        var queue = [start]
        while !queue.isEmpty {
            let pos = queue.removeFirst()
            let neighbours = [
                pos.above(), pos.below(), pos.left(), pos.right(),
                pos.above().left(), pos.above().right(),
                pos.below().left(), pos.below().right()
            ].filter { board[safe: $0]?.isEmpty == false }
            for neighbour in neighbours {
                if let removed = unreached.remove(neighbour) {
                    queue.append(removed)
                }
            }
        }
        return unreached.isEmpty
    }
    
    mutating func placePiece(_ piece: Piece, at position: Position) -> Bool {
        guard isValidPosition(for: piece, position: position) else {
            return false
        }
        piecesPositions[piece, default: []].insert(position)
        board[position].push(piece)
        return true
    }
    
}
