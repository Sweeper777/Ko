import UIKit
import KoModel

class ViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = boardView.intrinsicContentSize
        scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.contentSize.width / 2 - scrollView.bounds.width / 2,
                                           y: scrollView.contentSize.height / 2 - scrollView.bounds.height / 2)
        
        let game = Game()
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
        if position != boardView.selectedPosition {
            boardView.selectedPosition = position
        } else {
            boardView.selectedPosition = nil
        }
    }
}
