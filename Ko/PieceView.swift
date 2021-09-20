import UIKit
import KoModel
import SwiftyUtils

class PieceView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        clipsToBounds = false
    }
    
    var pieces: PieceStack = .init(){
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let piece = pieces.top else {
            return
        }
        
        let topProportion: CGFloat = 0.2
        let bottomProportion: CGFloat = 0.6
        let bottomHeightProportion: CGFloat = 0.4
        let fontSize: CGFloat = 16
        
        let lineWidth: CGFloat = 4
        let drawingRect = bounds.insetBy(dx: bounds.width * 0.1, dy: bounds.height * 0.1)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: drawingRect.minX + drawingRect.width * (1 - topProportion) / 2,
                              y: drawingRect.minY))
        path.addLine(to: CGPoint(x: drawingRect.minX,
                                 y: drawingRect.minY + drawingRect.height * (1 - bottomHeightProportion)))
        path.addLine(to: CGPoint(x: drawingRect.minX + drawingRect.width * (1 - bottomProportion) / 2,
                                 y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX - drawingRect.width * (1 - bottomProportion) / 2,
                                 y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX,
                                 y: drawingRect.minY + drawingRect.height * (1 - bottomHeightProportion)))
        path.addLine(to: CGPoint(x: drawingRect.maxX - drawingRect.width * (1 - topProportion) / 2,
                              y: drawingRect.minY))
        path.close()
        path.lineWidth = lineWidth
        let textColor: UIColor
        let textOffset: CGFloat
        switch piece.color {
        case .blue:
            UIColor.systemBlue.setFill()
            UIColor.systemBlue.lighter().setStroke()
            textColor = .white
            textOffset = 5
        case .white:
            UIColor.white.setFill()
            UIColor.white.darker().setStroke()
            textColor = .black
            textOffset = -5
            path.apply(CGAffineTransform(scaleX: 1, y: -1))
            path.apply(CGAffineTransform(translationX: 0, y: bounds.height))
        }
        if isSelected {
            UIColor.systemRed.setStroke()
        }
        path.fill()
        path.stroke()
        
        if pieces.count > 1 {
            let stackedPiecePath = UIBezierPath()
            stackedPiecePath.move(to: CGPoint(x: drawingRect.minX + drawingRect.width * (1 - bottomProportion) / 2,
                                              y: drawingRect.maxY + 2 * lineWidth))
            stackedPiecePath.addLine(to: CGPoint(x: drawingRect.maxX - drawingRect.width * (1 - bottomProportion) / 2,
                                                 y: drawingRect.maxY + 2 * lineWidth))
            stackedPiecePath.lineWidth = lineWidth
            stackedPiecePath.stroke()
        }
        
        let text: String
        switch piece.type {
        case .field:
            return
        case .empress:
            text = "E"
        case .burrow:
            text = "B"
        case .rabbit:
            text = "R"
        case .hare:
            text = "H"
        case .moon:
            text = "M"
        }
        let attrString = NSAttributedString(string: text, attributes: [
            .foregroundColor: textColor,
            .font: UIFont.boldSystemFont(ofSize: fontSize)
        ])
        let textSize = attrString.size()
        let textRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
            .insetBy(dx: -textSize.width / 2, dy: -textSize.height / 2)
            .applying(CGAffineTransform(translationX: 0, y: textOffset))
        attrString.draw(in: textRect)
    }
}