import UIKit
import KoModel

class HelpPageViewController: UIViewController {
    @IBOutlet var boardView: BoardView!
    @IBOutlet var label: UILabel!
    var helpPage: HelpPage!
    
    override func viewDidLoad() {
        boardView.boardProvider = helpPage.board
        boardView.updatePieceViews()
        label.text = helpPage.helpText
        boardView.highlightMoves(helpPage.highlightedMoves)
        boardView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let moveResult = helpPage.animatedMoveResult {
            boardView.boardProvider = helpPage.resultBoard
            boardView.animateMoveResult(moveResult)
        }
    }
    
}

extension HelpPageViewController: BoardViewDelegate {
    func didTapPosition(_ boardView: BoardView, position: Position) {
        
    }
    
    func didEndAnimatingMove(_ boardView: BoardView, moveResult: MoveResult) {
        boardView.updatePieceViews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            boardView.boardProvider = self?.helpPage.board
            boardView.updatePieceViews()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                boardView.boardProvider = self?.helpPage.resultBoard
                boardView.animateMoveResult(moveResult)
            }
            
        }
    }
    
    func highlightedMoves(for position: Position) -> [Move] {
        []
    }
    
    
}

struct HelpPage {
    init(board: ConstantBoard? = nil, resultBoard: ConstantBoard? = nil,
         animatedMoveResult: MoveResult? = nil,
         helpText: String, highlightedMoves: [Move] = []) {
        self.board = board
        self.resultBoard = resultBoard
        self.animatedMoveResult = animatedMoveResult
        self.helpText = helpText
        self.highlightedMoves = highlightedMoves
    }
    
    let board: ConstantBoard?
    let resultBoard: ConstantBoard?
    let animatedMoveResult: MoveResult?
    let helpText: String
    let highlightedMoves: [Move]
}
