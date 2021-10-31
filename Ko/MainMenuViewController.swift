import UIKit
import SwiftyButton
import SwiftyUtils

class MainMenuViewController : UIViewController {
    @IBOutlet var startButton: PressableButton!
    @IBOutlet var connectButton: PressableButton!
    @IBOutlet var helpButton: PressableButton!

    override func viewDidLoad() {
        startButton.setTitle("START", for: .normal)
        startButton.colors = PressableButton.ColorSet(
                button: UIColor.green.desaturated().darker(),
                shadow: UIColor.green.desaturated().darker().darker())
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        connectButton.setTitle("CONNECT", for: .normal)
        connectButton.colors = PressableButton.ColorSet(
                button: UIColor.yellow.darker().desaturated(),
                shadow: UIColor.yellow.darker().desaturated().darker())
        connectButton.addTarget(self, action: #selector(connectTapped), for: .touchUpInside)
        
        helpButton.setTitle("HELP", for: .normal)
        helpButton.colors = PressableButton.ColorSet(
                button: UIColor.blue.desaturated(),
                shadow: UIColor.blue.desaturated().darker())
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)

    }

    @objc func startTapped() {
        let gameVC = instantiateGameViewController(withStrategy: { vc in
            DefaultGameControllerStrategy(gameViewController: vc)
        })
        gameVC.map { present($0, animated: true, completion: nil) }
    }
    
    func instantiateGameViewController(withStrategy strategyProvider: (GameViewController) -> GameControllerStrategy) -> GameViewController? {
        guard let gameVC = UIStoryboard.main?.instantiateViewController(identifier: "GameVC") as? GameViewController else {
            return nil
        }
        gameVC.modalPresentationStyle = .fullScreen
        gameVC.strategy = strategyProvider(gameVC)
        return gameVC
    }

    @objc func connectTapped() {
        performSegue(withIdentifier: "showConnectVC", sender: nil)
    }
    
    @objc func helpTapped() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let connectVC = segue.destination as? ConnectViewController {
            connectVC.delegate = self
            print("prepared segue")
        }
    }
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
