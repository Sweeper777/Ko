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
}
