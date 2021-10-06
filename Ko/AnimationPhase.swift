import KoModel

protocol AnimationPhase: AnyObject {
    associatedtype AnimatedObject
    var duration: TimeInterval { get }
    var onEnd: (() -> Void)? { get set }
    func start(animations: [AnimationType: [AnimatedObject]])
    init(duration: TimeInterval)
}
