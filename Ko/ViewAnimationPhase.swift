import UIKit


class ViewAnimationPhase: AnimationPhase {

    let duration: TimeInterval
    static let invisibleScale: CGFloat = 0.000001

    var onEnd: (() -> Void)?

    func start(animations: [AnimationType: [UIView]]) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let `self` = self else { return }
            for (type, views) in animations {
                let block = self.animationBlock(for: type)
                views.forEach(block)
            }
        }, completion: { [weak self] _ in self?.onEnd?() })
    }

    private func animationBlock(for type: AnimationType) -> (UIView) -> Void {
        { _ in }
        // TODO
    }

    required init(duration: TimeInterval) {
        self.duration = duration
    }

    typealias AnimatedObject = UIView

}
