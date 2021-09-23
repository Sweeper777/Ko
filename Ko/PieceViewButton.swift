import UIKit

class PieceViewButton: PieceView {
    
    var tapped: ((PieceViewButton) -> Void)?
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapped?(self)
    }
}
