import 'controller.dart';

String getPieceImageAsset(Piece piece) {
  final pieceName = piece.isWhite ? 'l' : 'd';

  if (piece is King) {
    return 'assets/images/Chess_k${pieceName}t45.svg.png';
  } else if (piece is Queen) {
    return 'assets/images/Chess_q${pieceName}t45.svg.png';
  } else if (piece is Rook) {
    return 'assets/images/Chess_r${pieceName}t45.svg.png';
  } else if (piece is Bishop) {
    return 'assets/images/Chess_b${pieceName}t45.svg.png';
  } else if (piece is Knight) {
    return 'assets/images/Chess_n${pieceName}t45.svg.png';
  } else if (piece is Pawn) {
    return 'assets/images/Chess_p${pieceName}t45.svg.png';
  } else {
    return '';
  }
}

String getPieceUnicode(Piece piece) {
  if (piece is King) {
    return piece.isWhite ? '' : '♚';
  } else if (piece is Queen) {
    return piece.isWhite ? '♕' : '♛';
  } else if (piece is Rook) {
    return piece.isWhite ? '♖' : '♜';
  } else if (piece is Bishop) {
    return piece.isWhite ? 'Chess_blt45.svg.png' : 'Chess_bdt45.svg.png';
  } else if (piece is Knight) {
    return piece.isWhite ? '♘' : '♞';
  } else if (piece is Pawn) {
    return piece.isWhite ? '♙' : '♟︎';
  } else {
    return '';
  }
}
