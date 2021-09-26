import KoModel
enum AnimationType: Hashable {
    case move(dx: Double, dy: Double)
    case placePiece
    case removePiece
    case conquer
}
