import UIKit


class PieceViewAnimationPhase: AnimationPhase {

    let duration: TimeInterval
    static let invisibleScale: CGFloat = 0.000001

    var onEnd: (() -> Void)?

    func start(animations: [AnimationType: [CAShapeLayer]]) {
        CATransaction.setCompletionBlock { [weak self] in
            CATransaction.setCompletionBlock(nil)
            self?.onEnd?()
        }
        CATransaction.setAnimationDuration(duration)
        CATransaction.begin()
        for (type, layers) in animations {
            let block = self.animationBlock(for: type)
            layers.forEach(block)
        }
        CATransaction.commit()
    }

    private func animationBlock(for type: AnimationType) -> (CAShapeLayer) -> Void {
        switch type {
        case .move(let dx, let dy):
            return {
                $0.position = $0.position.applying(CGAffineTransform(translationX: CGFloat(dx), y: CGFloat(dy)))
            }
        case .appear:
            return { $0.transform = CATransform3DMakeScale(1, 1, 1) }
        case .disappear:
            return { $0.setAffineTransform($0.affineTransform().scaledBy(x: 0, y: 0)) }
        case .changeColor(let fill, let border, let text):
            return {
                $0.fillColor = fill
                $0.strokeColor = border
                ($0.sublayers?.first as? CATextLayer)?.foregroundColor = text
            }
        case .rotate:
            return {
                $0.setAffineTransform($0.affineTransform().rotated(by: .pi))
            }
        }
    }

    required init(duration: TimeInterval) {
        self.duration = duration
    }
}
