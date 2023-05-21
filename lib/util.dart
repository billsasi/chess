import 'package:chess/chess.dart' as chess;

String getPieceImageAsset(chess.Piece piece) {
  final pieceName = piece.color == chess.Color.WHITE ? 'l' : 'd';

  if (piece.type == chess.PieceType.KING) {
    return 'assets/images/Chess_k${pieceName}t45.svg.png';
  } else if (piece.type == chess.PieceType.QUEEN) {
    return 'assets/images/Chess_q${pieceName}t45.svg.png';
  } else if (piece.type == chess.PieceType.ROOK) {
    return 'assets/images/Chess_r${pieceName}t45.svg.png';
  } else if (piece.type == chess.PieceType.BISHOP) {
    return 'assets/images/Chess_b${pieceName}t45.svg.png';
  } else if (piece.type == chess.PieceType.KNIGHT) {
    return 'assets/images/Chess_n${pieceName}t45.svg.png';
  } else if (piece.type == chess.PieceType.PAWN) {
    return 'assets/images/Chess_p${pieceName}t45.svg.png';
  } else {
    return '';
  }
}

String convertToChessNotation(int square) {
  int file = square & 0x07;
  int rank = (square >> 4) + 1;
  String fileChar = String.fromCharCode('a'.codeUnitAt(0) + file);
  return fileChar + rank.toString();
}


// String getPieceUnicode(Piece piece) {
//   if (piece is King) {
//     return piece.isWhite ? '' : '♚';
//   } else if (piece is Queen) {
//     return piece.isWhite ? '♕' : '♛';
//   } else if (piece is Rook) {
//     return piece.isWhite ? '♖' : '♜';
//   } else if (piece is Bishop) {
//     return piece.isWhite ? 'Chess_blt45.svg.png' : 'Chess_bdt45.svg.png';
//   } else if (piece is Knight) {
//     return piece.isWhite ? '♘' : '♞';
//   } else if (piece is Pawn) {
//     return piece.isWhite ? '♙' : '♟︎';
//   } else {
//     return '';
//   }
// }
