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
    
    mutating func placePiece(_ piece: Piece, at position: Position) {
        piecesPositions[piece, default: []].insert(position)
        board[position].push(piece)
    }
    
    @discardableResult
    mutating func removePiece(at position: Position) -> Piece? {
        guard let popped = board[safe: position]?.pop() else {
            return nil
        }
        piecesPositions[popped]?.remove(position)
        return popped
    }
    
    @discardableResult
    mutating func removePiece(at position: Position, stackIndex: Int) -> Piece {
        let piece = board[position].remove(at: stackIndex)
        piecesPositions[piece]?.remove(position)
        return piece
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
            board[pos].pop()
            board[pos].push(Piece(opposingColor, .field))
        }
        piecesPositions[Piece(fieldColor, .field)]?.subtract(positions)
        piecesPositions[Piece(opposingColor, .field)]?.formUnion(positions)
        return true
    }
}
