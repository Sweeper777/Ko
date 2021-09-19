import UIKit
import KoModel

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
    }
}
