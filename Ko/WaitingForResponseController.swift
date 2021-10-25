import UIKit

class WaitingForResponseController: UIViewController {
    @IBOutlet var waitingForResponseBanner: UIView!
    
    override func viewDidLoad() {
        waitingForResponseBanner.layer.cornerRadius = 7
    }
}
