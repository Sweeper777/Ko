import UIKit
import KoModel
import SCLAlertView
import TYMProgressBarView

class GameViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boardView: BoardView!
    @IBOutlet var pieceSelector: PieceSelectorView!
    @IBOutlet var blueProgress: TYMProgressBarView!
    @IBOutlet var whiteProgress: TYMProgressBarView!
    @IBOutlet var blueFieldCountLabel: UILabel!
    @IBOutlet var whiteFieldCountLabel: UILabel!
    @IBOutlet var containerStackView: UIStackView!
    
    var game: Game!
    
    var strategy: GameControllerStrategy!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = boardView.intrinsicContentSize
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - scrollView.bounds.width / 2,
                                           y: scrollView.contentSize.height / 2 - scrollView.bounds.height / 2)
        
        boardView.delegate = self
        pieceSelector.delegate = self
        
        configureProgressBar(blueProgress, color: UIColor(named: "bluePlayerColor")!)
        configureProgressBar(whiteProgress, color: UIColor(named: "whitePlayerColor")!)
        
    }
    
    func restartGame() {
        game = Game()
        boardView.game = game
        boardView.updatePieceViews()
        updateViews()
        pieceSelector.selectablePieces = game.allPlaceablePieces()
        strategy.didRestartGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        restartGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerScrollViewContent()
        
    }
    
    func configureProgressBar(_ progressBar: TYMProgressBarView, color: UIColor) {
        progressBar.barBackgroundColor = .clear
        progressBar.barBorderColor = color
        progressBar.barBorderWidth = 4
        progressBar.barFillColor = color
        progressBar.barInnerBorderColor = .clear
        progressBar.barInnerPadding = 4
        progressBar.barInnerBorderWidth = 0
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
    }
    
    fileprivate func centerScrollViewContent() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    @IBAction func closeTapped() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("Yes", action: quitGame)
        alert.addButton("No", action: {})
        alert.showWarning("Confirm", subTitle: "Do you really want to quit?")
    }
    @objc func quitGame() {
        dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        boardView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewContent()
    }
}

extension GameViewController: BoardViewDelegate {
    func didTapPosition(_ boardView: BoardView, position: Position) {
        let moveToMake: Move
        let validMove: Bool
        switch pieceSelector.selectedPiece?.type {
        case nil:
            if let selectedPosition = boardView.selectedPosition {
                validMove = boardView.highlightedPositions.contains(position)
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
                validMove = boardView.highlightedPositions.contains(position)
                moveToMake = .placePiece(type, at: position)
            }
        }
        strategy.willMove(moveToMake)
        if validMove,
           let moveResult = game.makeMoveUnchecked(moveToMake) {
            setUserInteractionEnabled(false)
            boardView.animateMoveResult(moveResult)
            updateViews()
        }
    }
    
    func setUserInteractionEnabled(_ enabled: Bool) {
        boardView.isUserInteractionEnabled = enabled
        pieceSelector.isUserInteractionEnabled = enabled
    }
}

extension GameViewController: PieceSelectorDelegate {
    func pieceSelectorValueDidChange(_ pieceSelector: PieceSelectorView, selectedPiece: Piece?) {
        boardView.selectedPosition = nil
        if let selectedPieceType = selectedPiece?.type {
            boardView.highlightMoves(PlacePieceMoveGenerator.generateMoves(forPlacing: selectedPieceType, game: game))
        } else {
            boardView.highlightedPositions = []
        }
    }
    
    func didEndAnimatingMove(_ boardView: BoardView, moveResult: MoveResult) {
        switch game.result {
        case .wins(let color):
            SCLAlertView().showInfo("Game Over!", subTitle: "\(color) wins!")
        case .draw:
            SCLAlertView().showInfo("Game Over!", subTitle: "It's a draw!")
        case .notDetermined:
            setUserInteractionEnabled(true)
        }
        strategy.didEndAnimatingMoveResult(moveResult)
    }
}
