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
            setupLayers()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var pieceLayers: [CAShapeLayer] = []
    private var textLayer: CATextLayer?
    
    private func setupLayers() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        for _ in pieces {
            let pieceLayer = CAShapeLayer()
            pieceLayers.append(pieceLayer)
            layer.addSublayer(pieceLayer)
        }
        if !pieces.isEmpty {
            textLayer = CATextLayer()
            layer.addSublayer(textLayer!)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        let topProportion: CGFloat = 0.2
        let bottomProportion: CGFloat = 0.6
        let bottomHeightProportion: CGFloat = 0.4
        let fontSize: CGFloat = 16
        
        let lineWidth: CGFloat = 4
        let drawingRect = bounds.insetBy(dx: bounds.width * 0.1, dy: bounds.height * 0.1)
        for (piece, layer) in zip(pieces, pieceLayers) {
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
            layer.lineWidth = lineWidth
            switch piece.color {
            case .blue:
                layer.fillColor = UIColor(named: "bluePlayerColor")?.cgColor
                layer.strokeColor = UIColor(named: "bluePlayerColor")?.lighter().cgColor
            case .white:
                layer.fillColor = UIColor(named: "whitePlayerColor")?.cgColor
                layer.strokeColor = UIColor(named: "whitePlayerColor")?.darker().cgColor
                path.apply(CGAffineTransform(scaleX: 1, y: -1))
                path.apply(CGAffineTransform(translationX: 0, y: bounds.height))
            }
            if isSelected {
                layer.strokeColor = UIColor.red.cgColor
            }
            layer.path = path.cgPath
        }
        
        }
    }
}
