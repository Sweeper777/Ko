import UIKit
import KoModel

class HelpViewController: UIViewController {
    
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
            helpText: "Welcome to Ko, the national game of Pekoland! There are 6 kinds of pieces in this game. From left to right, top to bottom, the blue pieces are, Empress, Burrow, Field, Hare, Moon, Rabbit."
        ),
        HelpPage(
            board: .init(columnCount: 3, rowCount: 3) { place in
                place(Piece(.blue, .field), .init(2, 2))
                place(Piece(.blue, .empress), .init(1, 1))
                place(Piece(.blue, .field), .init(1, 2))
                place(Piece(.blue, .field), .init(2, 1))
                place(Piece(.blue, .field), .init(0, 1))
                place(Piece(.blue, .moon), .init(1, 0))
            },
            helpText: "The goal of the game is to create the Empress' Castle (shown above) at one corner of the board, and have at least 60 field pieces and 3 burrows. The Empress' Castle consists of a field piece at the corner, 3 field pieces surrounding 3 sides of the empress, and the moon on her remaining side."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .empress), .init(2, 2))
            },
            helpText: "The empress can move to any one of its 8 neighbouring squares. These are also the places where you can place new pieces.",
            highlightedMoves: Position(2, 2).eightNeighbours.map {
                .move(from: .init(2, 2), to: $0)
            }
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .empress), .init(2, 2))
                place(Piece(.white, .empress), .init(2, 1))
            },
            helpText: "In the 8 neighbouring squares of an empress, there cannot be another empress. For example, the board position above is invalid."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .field), .init(2, 2))
                place(Piece(.blue, .field), .init(1, 2))
                place(Piece(.white, .field), .init(3, 2))
                place(Piece(.white, .field), .init(4, 2))
            },
            helpText: "Fields are immovable pieces that can be conquered (changed into the opposite color)"
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .burrow), .init(2, 2))
                place(Piece(.blue, .field), .init(1, 2))
                place(Piece(.blue, .field), .init(3, 2))
                place(Piece(.blue, .field), .init(2, 1))
                place(Piece(.blue, .field), .init(2, 3))
                place(Piece(.blue, .field), .init(1, 1))
                place(Piece(.blue, .field), .init(3, 3))
                place(Piece(.blue, .field), .init(3, 1))
                place(Piece(.blue, .field), .init(1, 3))
            },
            helpText: "Burrows are immovable pieces that can be placed inside of a square of 8 fields as shown."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .burrow), .init(2, 2))
                place(Piece(.blue, .field), .init(1, 2))
                place(Piece(.blue, .field), .init(3, 2))
                place(Piece(.blue, .field), .init(2, 1))
                place(Piece(.blue, .field), .init(2, 3))
                place(Piece(.blue, .field), .init(1, 1))
                place(Piece(.blue, .field), .init(3, 3))
                place(Piece(.blue, .field), .init(3, 1))
                place(Piece(.blue, .field), .init(1, 3))
                place(Piece(.blue, .empress), .init(0, 2))
            },
            helpText: "To place a burrow, the empress has to be touching the square of 8 fields. Once placed, all 8 fields are conquered, if not already."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .rabbit), .init(1, 2))
                place(Piece(.blue, .field), .init(2, 2))
                place(Piece(.white, .field), .init(3, 2))
            },
            helpText: "Rabbits can move to any one of its 8 neighbouring squares. It can also jump over occupied squares in any direction to an empty square.",
            highlightedMoves: [
                Position(0, 2),
                Position(1, 3),
                Position(1, 1),
                Position(0, 1),
                Position(0, 3),
                Position(2, 3),
                Position(2, 1),
                Position(4, 2),
            ].map { .move(from: .init(1, 2), to: $0) }
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .rabbit), .init(4, 0))
                place(Piece(.white, .field), .init(3, 1))
                place(Piece(.white, .field), .init(2, 2))
                place(Piece(.white, .field), .init(1, 3))
            },
            resultBoard: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .rabbit), .init(0, 4))
                place(Piece(.blue, .field), .init(3, 1))
                place(Piece(.blue, .field), .init(2, 2))
                place(Piece(.blue, .field), .init(1, 3))
            },
            animatedMoveResult: MoveResult(conqueredPositions: [.init(3, 1), .init(2, 2), .init(1, 3)], fromPosition: .init(4, 0), toPosition: .init(0, 4)),
            helpText: "If a rabbit jumps over a diagonal line of fields of the opposite color, all of them are conquered."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .hare), .init(0, 0))
                place(Piece(.blue, .field), .init(0, 1))
                place(Piece(.white, .field), .init(1, 0))
            },
            helpText: "Hares can move vertically or horizontally, at most 3 times. It can also go on top of fields, rabbits and other hares. Pieces that are under a hare cannot move.",
            highlightedMoves: [
                Position(0, 1),
                Position(0, 2),
                Position(0, 3),
                Position(1, 1),
                Position(1, 0),
                Position(1, 2),
                Position(2, 0),
                Position(2, 1),
                Position(3, 0),
            ].map { .move(from: .init(0, 0), to: $0) }
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .hare), .init(2, 0))
                place(Piece(.white, .field), .init(2, 1))
                place(Piece(.white, .field), .init(2, 2))
                place(Piece(.white, .field), .init(2, 3))
            },
            resultBoard: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .hare), .init(2, 4))
                place(Piece(.blue, .field), .init(2, 1))
                place(Piece(.blue, .field), .init(2, 2))
                place(Piece(.blue, .field), .init(2, 3))
            },
            animatedMoveResult: MoveResult(conqueredPositions: [.init(2, 1), .init(2, 2), .init(2, 3)], fromPosition: .init(2, 0), toPosition: .init(2, 4)),
            helpText: "A hare can jump over a vertical or horizontal line of fields of the opposite color (no matter how long) to an empty square, to conquer all of them."
        ),
        HelpPage(
            board: .init(columnCount: 5, rowCount: 5) { place in
                place(Piece(.blue, .moon), .init(2, 2))
            },
            helpText: "Moons can move horizontally or vertically an unlimited number of times, so it can reach any empty square on the board unless it is trapped.",
            highlightedMoves: (0..<5).flatMap { x in (0..<5).filter { y in (x, y) != (2, 2) }.map { y in Position(x, y) } }.map { .move(from: .init(2, 2), to: $0) }
        ),
    ].map(helpPageVC(fromHelpPage:))
    
    
    private func helpPageVC(fromHelpPage helpPage: HelpPage) -> UIViewController {
        let vc = UIStoryboard.main!.instantiateViewController(withIdentifier: "HelpPage") as! HelpPageViewController
        vc.helpPage = helpPage
        return vc
    }
    
    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPageVC",
            let pageVC = segue.destination as? UIPageViewController {
            pageVC.delegate = self
            pageVC.dataSource = self
            pageVC.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension HelpViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), pages.indices.contains(index - 1) {
            return pages[index - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.firstIndex(of: viewController), pages.indices.contains(index + 1) {
            return pages[index + 1]
        } else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let page = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: page) {
            return index
        } else {
            return 0
        }
    }
}
