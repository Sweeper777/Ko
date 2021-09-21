import UIKit
import KoModel

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boardView: BoardView!
    @IBOutlet var moveModeSelector: UISegmentedControl!
    
    let game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = boardView.intrinsicContentSize
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - scrollView.bounds.width / 2,
                                           y: scrollView.contentSize.height / 2 - scrollView.bounds.height / 2)
        
        boardView.game = game
        _ = game.makeMove(.placePiece(.field, at: .init(9, 9)))
        _ = game.makeMove(.placePiece(.field, at: .init(9, 8)))
        _ = game.makeMove(.placePiece(.field, at: .init(10, 9)))
        _ = game.makeMove(.placePiece(.field, at: .init(10, 8)))
        _ = game.makeMove(.placePiece(.field, at: .init(11, 9)))
        _ = game.makeMove(.placePiece(.field, at: .init(11, 8)))
        _ = game.makeMove(.placePiece(.field, at: .init(11, 10)))
        _ = game.makeMove(.placePiece(.field, at: .init(11, 7)))
        _ = game.makeMove(.placePiece(.empress, at: .init(11, 11)))
        _ = game.makeMove(.placePiece(.empress, at: .init(11, 6)))
        boardView.updatePieceViews()
        boardView.delegate = self
    }

    @IBAction func moveModeChanged() {
        if moveModeSelector.selectedSegmentIndex != 0 {
            boardView.selectedPosition = nil
        }
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
        switch moveModeSelector.selectedSegmentIndex {
        case 0:
            if let selectedPosition = boardView.selectedPosition {
                if selectedPosition == position {
                    boardView.selectedPosition = nil
                    return
                }
                moveToMake = .move(from: selectedPosition, to: position)
            } else if !game.board[position].isEmpty {
                boardView.selectedPosition = position
                return
            } else {
                return
            }
        case 1:
            moveToMake = .placePiece(.field, at: position)
        case 2:
            moveToMake = .placePiece(.empress, at: position)
        case 3:
            moveToMake = .placePiece(.burrow, at: position)
        case 4:
            moveToMake = .placePiece(.hare, at: position)
        case 5:
            moveToMake = .placePiece(.rabbit, at: position)
        case 6:
            moveToMake = .placePiece(.moon, at: position)
        default:
            return
        }
        if let moveResult = game.makeMove(moveToMake) {
            boardView.animateMoveResult(moveResult, completion: nil)
            boardView.selectedPosition = nil
        }
    }
}
