import UIKit
import SwiftyButton
import SwiftyUtils

class MainMenuViewController : UIViewController {
    @IBOutlet var startButton: PressableButton!
    @IBOutlet var connectButton: PressableButton!
    @IBOutlet var helpButton: PressableButton!

}

extension UIColor {

    func desaturated() -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: max(0, saturation - 0.2), brightness: brightness, alpha: alpha)
    }
}
