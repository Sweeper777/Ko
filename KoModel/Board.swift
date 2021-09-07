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
            return (piecesPositions[opposingMoon] ?? []).intersection(position.fourNeighbours).isEmpty &&
                (piecesPositions[opposingEmpress] ?? []).intersection(position.eightNeighbours).isEmpty
        }
        func isValidPositionForBurrow() -> Bool {
            guard board[position].isEmpty else {
                return false
            }
            let isSurroundedByFields = (piecesPositions[Piece(.blue, .field)] ?? []).union(piecesPositions[Piece(.white, .field)] ?? [])
                .isSuperset(of: position.eightNeighbours)
            let is4BlocksAwayFromAllBurrows = (piecesPositions[Piece(.blue, .burrow)] ?? []).union(piecesPositions[Piece(.white, .burrow)] ?? [])
                .allSatisfy { abs(position.x - $0.x) >= 5 && abs(position.y - $0.y) >= 5 }
            return isSurroundedByFields && is4BlocksAwayFromAllBurrows
        }
        func isValidPositionForMoon() -> Bool {
            guard board[position].isEmpty else {
                return false
            }
            let opposingMoon = Piece(piece.color.opposingColor, .moon)
            return (piecesPositions[opposingMoon] ?? []).intersection(position.eightNeighbours).isEmpty
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
            let neighbours = pos.eightNeighbours.filter { board[safe: $0]?.isEmpty == false }
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
    
    mutating func removePiece(at position: Position) -> Piece? {
        guard let popped = board[safe: position]?.pop() else {
            return nil
        }
        piecesPositions[popped]?.remove(position)
        return popped
    }
    
    
    @discardableResult
    mutating func conquerFields(positions: [Position]) -> Bool {
        guard let first = positions.first,
              let fieldColor = board[safe: first]?.top?.color else {
            return false
        }
        let opposingColor = fieldColor.opposingColor
        
        guard positions.allSatisfy({ board[safe: $0]?.top?.type == .field }) &&
            Set(positions.map { board[safe: $0]?.top?.color }).count == 1 else {
            return false
        }
        for pos in positions {
            board[pos].push(Piece(opposingColor, .field))
        }
        piecesPositions[Piece(fieldColor, .field)]?.subtract(positions)
        piecesPositions[Piece(opposingColor, .field)]?.formUnion(positions)
        return true
    }
}
