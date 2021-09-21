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
    }
    
    let squareLength: CGFloat = 54
    let lineWidth: CGFloat = 7
    
    var selectedPosition: Position? {
        didSet {
            if let tag = oldValue?.rawValue, let pieceView = viewWithTag(tag) as? PieceView {
                pieceView.isSelected = false
            }
            if let newTag = selectedPosition?.rawValue, let selectedView = viewWithTag(newTag) as? PieceView {
                selectedView.isSelected = true
            }
        }
    }
    
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
    
    func animateMoveResult(_ moveResult: MoveResult, completion: (() -> Void)?) {
        updatePieceViews()
        completion?()
    }
}

protocol BoardViewDelegate: AnyObject {
    func didTapPosition(_ boardView: BoardView, position: Position)
}
