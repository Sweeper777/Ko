import CoreGraphics
enum AnimationType: Hashable {
    case move(dx: Double, dy: Double)
    case appear
    case disappear
    case changeColor(fill: CGColor, border: CGColor, text: CGColor)
    case rotate
}
