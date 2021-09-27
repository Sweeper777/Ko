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
            for view in stackView.arrangedSubviews {
                if let pieceButton = view as? PieceView {
                    pieceButton.isSelected = pieceButton.pieces.top == selectedPiece
                }
            }
        }
    }
    
    private var stackView: UIStackView!
    
    weak var delegate: PieceSelectorDelegate?
    
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
    
    private func updatePieceViews() {
        let subviews = stackView.arrangedSubviews
        subviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        for piece in selectablePieces {
            let pieceView = PieceViewButton(frame: stackView.bounds)
            pieceView.translatesAutoresizingMaskIntoConstraints = false
            pieceView.widthAnchor.constraint(equalTo: pieceView.heightAnchor).isActive = true
            pieceView.isSelected = piece == selectedPiece
            pieceView.pieces.push(piece)
            pieceView.tapped = {
                [weak self] in
                if self?.selectedPiece == $0.pieces.top {
                    self?.selectedPiece = nil
                } else {
                    self?.selectedPiece = $0.pieces.top
                }
            }
            stackView.addArrangedSubview(pieceView)
        }
    }
}

protocol PieceSelectorDelegate: AnyObject {
    func pieceSelectorValueDidChange(_ pieceSelector: PieceSelectorView, selectedPiece: Piece?)
}
