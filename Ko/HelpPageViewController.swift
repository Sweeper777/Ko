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
    }
    
}

struct HelpPage {
    let board: ConstantBoard?
    let move: Move?
    let helpText: String
}
