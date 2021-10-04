import UIKit
import KoModel

class BoardView: UIView {
    var game: Game?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .systemGreen
        highlightLayer = CAShapeLayer()
        highlightLayer.fillColor = UIColor.systemYellow.cgColor
        highlightLayer.zPosition = 100
        layer.addSublayer(highlightLayer)
    }
    
    let squareLength: CGFloat = 54
    let lineWidth: CGFloat = 7
    
    var selectedPosition: Position? {
        didSet {
            if let tag = oldValue?.rawValue, let pieceView = viewWithTag(tag) as? PieceView {
                pieceView.isSelected = false
                highlightedPositions = []
            }
            if let selectedPos = selectedPosition, let selectedView = viewWithTag(selectedPos.rawValue) as? PieceView {
                selectedView.isSelected = true
                if let game = game {
                    switch game.board[selectedPos] {
                    case .empress:
                        highlightMoves(EmpressMoveGenerator.generateMoves(fromStartingPosition: selectedPos, game: game))
                    case .hare:
                        highlightMoves(HareMoveGenerator.generateMoves(fromStartingPosition: selectedPos, game: game))
                    case .rabbit:
                        highlightMoves(RabbitMoveGenerator.generateMoves(fromStartingPosition: selectedPos, game: game))
                    case .moon:
                        highlightMoves(MoonMoveGenerator.generateMoves(fromStartingPosition: selectedPos, game: game))
                    default:
                        break
                    }
                }
            }
        }
    }
    
    var highlightedPositions: [Position] = [] {
        didSet {
            setNeedsLayout()
        }
    }
    
    var highlightLayer: CAShapeLayer!
    
    weak var delegate: BoardViewDelegate?
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 8 * squareLength,
                                  y: 8 * squareLength,
                                  width: 3 * squareLength,
                                  height: squareLength))
            .fill()
        UIColor.systemBlue.setFill()
        UIBezierPath(rect: CGRect(x: 8 * squareLength,
                                  y: 9 * squareLength,
                                  width: 3 * squareLength,
                                  height: squareLength))
            .fill()
        
        UIColor.systemOrange.setStroke()
        for row in 0...GameConstants.boardRows {
            let path = UIBezierPath()
            let y = CGFloat(row) * squareLength
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: bounds.maxX, y: y))
            path.lineWidth = lineWidth
            path.stroke()
        }
        for col in 0...GameConstants.boardColumns {
            let path = UIBezierPath()
            let x = CGFloat(col) * squareLength
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: bounds.maxY))
            path.lineWidth = lineWidth
            path.stroke()
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let highlightPaths = highlightedPositions.map { pos -> UIBezierPath in
            let squareRect = CGRect(x: CGFloat(pos.x) * squareLength,
                                    y: CGFloat(pos.y) * squareLength,
                                    width: squareLength,
                                    height: squareLength)
            let origin = CGPoint(x: squareRect.midX, y: squareRect.midY)
            return UIBezierPath(ovalIn: CGRect(origin: origin, size: .zero)
                                        .insetBy(dx: -squareLength / 5, dy: -squareLength / 5))
        }
        let combinedPath = highlightPaths.reduce(into: UIBezierPath()) { combined, path in
            combined.append(path)
        }
        highlightLayer.path = combinedPath.cgPath
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: CGFloat(GameConstants.boardColumns) * squareLength,
               height: CGFloat(GameConstants.boardRows) * squareLength)
    }
    
    func updatePieceViews() {
        self.subviews.forEach { $0.removeFromSuperview() }
        guard let game = game else {
            return
        }
        for x in 0..<game.board.board.columns {
            for y in 0..<game.board.board.rows {
                addPieceView(atX: x, y: y)
            }
        }
    }
    
    private func addPieceView(atX x: Int, y: Int) {
        guard let game = game else { return }
        
        let stack = game.board.board[x, y]
        if !stack.isEmpty {
            let pieceView = PieceView(frame: CGRect(x: CGFloat(x) * squareLength,
                                                    y: CGFloat(y) * squareLength,
                                                    width: squareLength,
                                                    height: squareLength))
            addSubview(pieceView)
            pieceView.pieces = stack
            pieceView.tag = Position(x, y).rawValue
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.location(in: self)
        let (x, y) = (Int(location.x / squareLength), Int(location.y / squareLength))
        if (0..<(game?.board.board.columns ?? 0)).contains(x) && (0..<(game?.board.board.rows ?? 0)).contains(y) {
            delegate?.didTapPosition(self, position: Position(x, y))
        }
    }
    
    let animationManager = AnimationManager<PieceViewAnimationPhase>()
    
    func animateMoveResult(_ moveResult: MoveResult, completion: (() -> Void)?) {
        // 1. place/move
        // 2. conquer
        // 3. remove
        animationManager.reset()
        let animationDuration: TimeInterval = 0.2
        if let from = moveResult.fromPosition, let to = moveResult.toPosition {
            let dx = Double(CGFloat(to.x - from.x) * squareLength)
            let dy = Double(CGFloat(to.y - from.y) * squareLength)
            if let movingPieceView = viewWithTag(from.rawValue) as? PieceView,
               let movingPieceLayer = movingPieceView.pieceLayers.last {
                movingPieceView.isDirty = true
                bringSubviewToFront(movingPieceView)
                var animationGroup = [
                    AnimationType.move(dx: dx, dy: dy): [movingPieceLayer]
                ]
                if moveResult.hasCapture, let capturedPieceView = viewWithTag(to.rawValue) as? PieceView,
                   let capturedPieceLayer = capturedPieceView.pieceLayers.last {
                    capturedPieceView.isDirty = true
                    animationGroup[.disappear] = [capturedPieceLayer]
                }
                animationManager.addPhase(group: animationGroup, duration: animationDuration) { [weak self] in
                    movingPieceView.isDirty = false
                    movingPieceView.pieces = self?.game?.board[from] ?? .init()
                    if movingPieceView.pieces.isEmpty {
                        movingPieceView.removeFromSuperview()
                    }
                    if let destinationPieceView = self?.viewWithTag(to.rawValue) as? PieceView {
                        destinationPieceView.isDirty = false
                        destinationPieceView.pieces = self?.game?.board[from] ?? .init()
                    } else {
                        self?.addPieceView(atX: to.x, y: to.y)
                    }
                }
            }
        }
        
        if let placementRecord = moveResult.piecePlaced {
            self.addPieceView(atX: placementRecord.position.x, y: placementRecord.position.y)
            if let placedPieceView = viewWithTag(placementRecord.position.rawValue) as? PieceView,
               let placedPieceLayer = placedPieceView.pieceLayers.last {
                placedPieceView.isDirty = true
                placedPieceView.refreshLayers()
                placedPieceLayer.setAffineTransform(CGAffineTransform(scaleX: 0, y: 0))
                animationManager.addPhase(group: [.appear: [placedPieceLayer]],
                                          duration: animationDuration) {
                    placedPieceView.isDirty = false
                }
            }
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.animationManager.runAnimation { [weak self] in
                self?.updatePieceViews()
                completion?()
            }
        }
    }
    
    func highlightMoves<S: Sequence>(_ moves: S) where S.Element == Move {
        highlightedPositions = []
        for move in moves {
            switch move {
            case .move(from: _, let to):
                highlightedPositions.append(to)
            case .placePiece(_, let at):
                highlightedPositions.append(at)
            }
        }
    }
}

protocol BoardViewDelegate: AnyObject {
    func didTapPosition(_ boardView: BoardView, position: Position)
}
