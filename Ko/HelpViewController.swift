import UIKit
import KoModel

class HelpViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    
    lazy var pages = [
        HelpPage(
            board: .init(columnCount: 5, rowCount: 4) { place in
                place(Piece(.white, .empress), .init(1, 0))
                place(Piece(.white, .burrow), .init(2, 0))
                place(Piece(.white, .field), .init(3, 0))
                place(Piece(.white, .hare), .init(1, 1))
                place(Piece(.white, .moon), .init(2, 1))
                place(Piece(.white, .rabbit), .init(3, 1))
                
                place(Piece(.blue, .empress), .init(1, 2))
                place(Piece(.blue, .burrow), .init(2, 2))
                place(Piece(.blue, .field), .init(3, 2))
                place(Piece(.blue, .hare), .init(1, 3))
                place(Piece(.blue, .moon), .init(2, 3))
                place(Piece(.blue, .rabbit), .init(3, 3))
            },
            move: nil,
            helpText: "Welcome to Ko, the national game of Pekoland!"
        )
    ].map(helpPageVC(fromHelpPage:))
    
    private func helpPageVC(fromHelpPage helpPage: HelpPage) -> UIViewController {
        let vc = UIStoryboard.main!.instantiateViewController(withIdentifier: "HelpPage") as! HelpPageViewController
        vc.helpPage = helpPage
        return vc
    }
    
}

