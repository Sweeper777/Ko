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
            move: nil,
            helpText: "Welcome to Ko, the national game of Pekoland!"
        )
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
