import UIKit
import KoModel

class PieceSelectorView: UIView {
    var selectablePieces: [Piece] = [] {
        didSet {
            updatePieceViews()
        }
    }
    var selectedPiece: Piece? {
        didSet {
            delegate?.pieceSelectorValueDidChange(self, selectedPiece: selectedPiece)
            updatePieceViews()
        }
    }
    
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        stackView = UIStackView(frame: bounds)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

