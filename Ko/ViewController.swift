import UIKit
import KoModel
import SCLAlertView
import TYMProgressBarView

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boardView: BoardView!
    @IBOutlet var pieceSelector: PieceSelectorView!
    @IBOutlet var blueProgress: TYMProgressBarView!
    @IBOutlet var whiteProgress: TYMProgressBarView!
    @IBOutlet var blueFieldCountLabel: UILabel!
    @IBOutlet var whiteFieldCountLabel: UILabel!
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = boardView.intrinsicContentSize
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - scrollView.bounds.width / 2,
                                           y: scrollView.contentSize.height / 2 - scrollView.bounds.height / 2)
        
        boardView.game = game
        game.placeFieldsForDebugging()
        boardView.updatePieceViews()
        boardView.delegate = self
        pieceSelector.delegate = self
        
        blueProgress.barBackgroundColor = .clear
        blueProgress.barBorderColor = .systemBlue
        blueProgress.barBorderWidth = 4
        blueProgress.barFillColor = .systemBlue
        blueProgress.barInnerBorderColor = .clear
        blueProgress.barInnerPadding = 4
        blueProgress.barInnerBorderWidth = 0
        
        whiteProgress.barBackgroundColor = .clear
        whiteProgress.barBorderColor = .white
        whiteProgress.barBorderWidth = 4
        whiteProgress.barFillColor = .white
        whiteProgress.barInnerBorderColor = .clear
        whiteProgress.barInnerPadding = 4
        whiteProgress.barInnerBorderWidth = 0
        
        updateViews()
    }
    
    func updateViews() {
        boardView.selectedPosition = nil
        pieceSelector.selectedPiece = nil
        let blueFieldCount = game.board.piecesPositions[Piece(.blue, .field)]?.count ?? 0
        let whiteFieldCount = game.board.piecesPositions[Piece(.white, .field)]?.count ?? 0
        blueProgress.progress = min(1, CGFloat(blueFieldCount) / CGFloat(GameConstants.requiredFieldCountForCastle))
        whiteProgress.progress = min(1, CGFloat(whiteFieldCount) / CGFloat(GameConstants.requiredFieldCountForCastle))
        blueFieldCountLabel.text = "\(blueFieldCount)"
        whiteFieldCountLabel.text = "\(whiteFieldCount)"
        pieceSelector.selectablePieces = game.allPlaceablePieces()
    }
}

extension ViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        boardView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

extension ViewController: BoardViewDelegate {
    func didTapPosition(_ boardView: BoardView, position: Position) {
        let moveToMake: Move
        switch pieceSelector.selectedPiece?.type {
        case nil:
            if let selectedPosition = boardView.selectedPosition {
                boardView.selectedPosition = nil
                if selectedPosition == position {
                    return
                }
                moveToMake = .move(from: selectedPosition, to: position)
            } else if !game.board[position].isEmpty {
                boardView.selectedPosition = position
                return
            } else {
                return
            }
        case let type?:
            if !game.board[position].isEmpty {
                pieceSelector.selectedPiece = nil
                boardView.selectedPosition = position
                return
            } else {
                moveToMake = .placePiece(type, at: position)
            }
        }
        if let moveResult = game.makeMove(moveToMake) {
            boardView.animateMoveResult(moveResult, completion: nil)
            updateViews()
            if case .wins(let color) = moveResult.gameResult {
                SCLAlertView().showInfo("Game Over!", subTitle: "\(color) wins!")
            } else if .draw == moveResult.gameResult {
                SCLAlertView().showInfo("Game Over!", subTitle: "It's a draw!")
            }
        }
    }
}

extension ViewController: PieceSelectorDelegate {
    func pieceSelectorValueDidChange(_ pieceSelector: PieceSelectorView, selectedPiece: Piece?) {
        boardView.selectedPosition = nil
        if let selectedPieceType = selectedPiece?.type {
            boardView.highlightMoves(PlacePieceMoveGenerator.generateMoves(forPlacing: selectedPieceType, game: game))
        } else {
            boardView.highlightedPositions = []
        }
    }
}
