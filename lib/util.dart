// import 'controller.dart';

// Takes a move in algebraic notation and returns start and end coordinates as list of tuples
List<List<int>> translateMove(String move) {
  // This assumes move is in format like 'e2e4', 'g1f3', etc.
  String start = move.substring(0, 2);
  String end = move.substring(2, 4);

  return [convertNotationToIndex(start), convertNotationToIndex(end)];
}

List<int> convertNotationToIndex(String square) {
  // Files run a-h from left to right (maps to 0-7 in array)
  int file = square.codeUnitAt(0) - 'a'.codeUnitAt(0);

  // Ranks run 1-8 from bottom to top (maps to 0-7 in array)
  int rank = int.parse(square[1]) - 1;

  // Return as [row, col] in array
  return [rank, file];
}


// String getPieceImageAsset(Piece piece) {
//   final pieceName = piece.isWhite ? 'l' : 'd';

//   if (piece is King) {
//     return 'assets/images/Chess_k${pieceName}t45.svg.png';
//   } else if (piece is Queen) {
//     return 'assets/images/Chess_q${pieceName}t45.svg.png';
//   } else if (piece is Rook) {
//     return 'assets/images/Chess_r${pieceName}t45.svg.png';
//   } else if (piece is Bishop) {
//     return 'assets/images/Chess_b${pieceName}t45.svg.png';
//   } else if (piece is Knight) {
//     return 'assets/images/Chess_n${pieceName}t45.svg.png';
//   } else if (piece is Pawn) {
//     return 'assets/images/Chess_p${pieceName}t45.svg.png';
//   } else {
//     return '';
//   }
// }

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
