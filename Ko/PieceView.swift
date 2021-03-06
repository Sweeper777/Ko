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
    
    var isDirty = false
    
    var pieceLayers: [CAShapeLayer] = []
    
    private func setupLayers() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        pieceLayers = []
        for _ in pieces {
            let pieceLayer = CAShapeLayer()
            pieceLayers.append(pieceLayer)
            layer.addSublayer(pieceLayer)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard !isDirty else {
            return
        }
        refreshLayers()
    }
    
    func refreshLayers() {
        let topProportion: CGFloat = 0.2
        let bottomProportion: CGFloat = 0.6
        let bottomHeightProportion: CGFloat = 0.4
        let fontSize: CGFloat = 16
        
        let lineWidth: CGFloat = 4
        let drawingRect = bounds.insetBy(dx: bounds.width * 0.1, dy: bounds.height * 0.1)
        for (index, (piece, layer)) in zip(pieces, pieceLayers).enumerated() {
            layer.frame = bounds
            layer.zPosition = CGFloat(index) * 2
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
            if isSelected, index == pieces.count - 1 {
                layer.strokeColor = UIColor.red.cgColor
            }
            layer.path = path.cgPath
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            let textLayer = CATextLayer()
            layer.zPosition = CGFloat(index) * 2 + 1
            layer.addSublayer(textLayer)
            let text: String
            switch piece.type {
            case .field:
                text = ""
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
            let textColor: UIColor
            let textOffset: CGFloat
            let initialTextTransform: CGAffineTransform
            switch piece.color {
            case .blue:
                textColor = .white
                textOffset = 5
                initialTextTransform = .identity
            case .white:
                textColor = .black
                textOffset = -5
                initialTextTransform = CGAffineTransform(rotationAngle: .pi)
            }
            let attrString = NSAttributedString(string: text, attributes: [
                .foregroundColor: textColor,
                .font: UIFont.boldSystemFont(ofSize: fontSize)
            ])
            let textSize = attrString.size()
            let textRect = CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0)
                        .insetBy(dx: -textSize.width / 2, dy: -textSize.height / 2)
                        .applying(CGAffineTransform(translationX: 0, y: textOffset))
            textLayer.frame = textRect
            textLayer.font = CGFont(UIFont.boldSystemFont(ofSize: fontSize).fontName as CFString)
            textLayer.fontSize = fontSize
            textLayer.string = text
            textLayer.foregroundColor = textColor.cgColor
            textLayer.alignmentMode = .center
            textLayer.setAffineTransform(initialTextTransform)
        }
    }
}
