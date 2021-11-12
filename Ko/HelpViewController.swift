import UIKit
import KoModel

class HelpViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    
    private func helpPageVC(fromHelpPage helpPage: HelpPage) -> UIViewController {
        let vc = UIStoryboard.main!.instantiateViewController(withIdentifier: "HelpPage") as! HelpPageViewController
        vc.helpPage = helpPage
        return vc
    }
    
}

