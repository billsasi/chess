class Board {
  List<List<Spot>> spots =
      List.generate(8, (i) => List.filled(8, Spot(0, 0, null)));

  void initBoard() {
    // initialize white pieces
    spots[0][0] = Spot(0, 0, Rook(true));
    spots[0][1] = Spot(0, 1, Knight(true));
    spots[0][2] = Spot(0, 2, Bishop(true));
    spots[0][3] = Spot(0, 3, Queen(true));
    spots[0][4] = Spot(0, 4, King(true));
    spots[0][5] = Spot(0, 5, Bishop(true));
    spots[0][6] = Spot(0, 6, Knight(true));
    spots[0][7] = Spot(0, 7, Rook(true));
    for (int i = 0; i < 8; i++) {
      spots[1][i] = Spot(1, i, Pawn(true));
    }

    // initialize black pieces
    spots[7][0] = Spot(7, 0, Rook(false));
    spots[7][1] = Spot(7, 1, Knight(false));
    spots[7][2] = Spot(7, 2, Bishop(false));
    spots[7][3] = Spot(7, 3, Queen(false));
    spots[7][4] = Spot(7, 4, King(false));
    spots[7][5] = Spot(7, 5, Bishop(false));
    spots[7][6] = Spot(7, 6, Knight(false));
    spots[7][7] = Spot(7, 7, Rook(false));
    for (int i = 0; i < 8; i++) {
      spots[6][i] = Spot(6, i, Pawn(false));
    }

    // initialize remaining spots without any piece
    for (int i = 2; i < 6; i++) {
      for (int j = 0; j < 8; j++) {
        spots[i][j] = Spot(i, j, null);
      }
    }
  }
}

class Spot {
  final int x;
  final int y;
  Piece? piece;

  Spot(this.y, this.x, this.piece);
}

abstract class Piece {
  final bool isWhite;
  bool isKilled;

  Piece(this.isWhite, this.isKilled);
  bool isValidMove(Board board, Spot start, Spot end);
}

class King extends Piece {
  King(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (start.x - end.x).abs();
    int y = (start.y - end.y).abs();
    if (x < 2 && y < 2 && x + y > 0) {
      return true;
    }
    return false;
  }
}

class Queen extends Piece {
  Queen(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (start.x - end.x).abs();
    int y = (start.y - end.y).abs();
    if ((x == y || x == 0 || y == 0) && x + y > 0) {
      if (isBlocked(start, end, board)) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class Bishop extends Piece {
  Bishop(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (start.x - end.x).abs();
    int y = (start.y - end.y).abs();
    if (x == y && x + y > 0) {
      if (isBlocked(start, end, board)) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class Knight extends Piece {
  Knight(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (start.x - end.x).abs();
    int y = (start.y - end.y).abs();
    if ((x == 1 && y == 2) || (x == 2 && y == 1)) {
      return true;
    }
    return false;
  }
}

class Rook extends Piece {
  Rook(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (start.x - end.x).abs();
    int y = (start.y - end.y).abs();

    if ((x == 0 || y == 0) && x + y > 0) {
      if (isBlocked(start, end, board)) {
        return false;
      }
      return true;
    }
    return false;
  }
}

class Pawn extends Piece {
  bool isFirstMove = true;

  Pawn(bool isWhite) : super(isWhite, false);

  @override
  bool isValidMove(Board board, Spot start, Spot end) {
    if (end.piece != null && end.piece!.isWhite == isWhite) {
      return false;
    }
    int x = (end.x - start.x);
    int y = (end.y - start.y);

    if (!isWhite) {
      y = -y;
    }

    // capturing move
    if (end.piece != null && x.abs() == 1 && y == 1) {
      return true;
    }

    if (isFirstMove) {
      if (x == 0 && y == 2) {
        return true;
      }
    }

    if (x == 0 && y == 1) {
      return true;
    }
    return false;
  }
}

bool isBlocked(Spot start, Spot end, Board board) {
  if (start.x == end.x && start.y == end.y) {
    // Same spot, not blocked
    return false;
  }

  int dx = end.x - start.x;
  int dy = end.y - start.y;

  int xDir = dx > 0
      ? 1
      : dx < 0
          ? -1
          : 0;
  int yDir = dy > 0
      ? 1
      : dy < 0
          ? -1
          : 0;

  int x = start.x + xDir;
  int y = start.y + yDir;

  while (x != end.x || y != end.y) {
    if (board.spots[y][x].piece != null) {
      // Spot is blocked
      return true;
    }
    x += xDir;
    y += yDir;
  }

  // Path is clear
  return false;
}

class Player {
  final bool isWhite;
  final String name;
  List<Piece> killedPieces = [];
  Player(this.isWhite, this.name);
}

class Move {
  final Player player;
  final Spot start;
  final Spot end;
  final Piece pieceMoved;
  final Piece? pieceKilled;
  Move(this.player, this.start, this.end, this.pieceMoved, this.pieceKilled);
}

enum GameStatus {
  active,
  check,
  whiteWin,
  blackWin,
  draw,
}

class Game {
  List<Player> players;
  Board? board;
  Player? currentPlayer;
  GameStatus? status;
  List<Move>? moves;

  Game(this.players) {
    board = Board();
    currentPlayer = players[0];
  }

  void startGame(Player p1, Player p2) {
    players = [p1, p2];
    status = GameStatus.active;
    board?.initBoard();
    if (p1.isWhite) {
      currentPlayer = p1;
    } else {
      currentPlayer = p2;
    }
  }

  bool playerMove(Spot start, Spot end) {
    // Spot start = board!.spots[startX][startY];
    // Spot end = board!.spots[endX][endY];
    if (start.piece == null) {
      return false;
    }
    Piece sourcePiece = start.piece!;
    if (sourcePiece.isWhite != currentPlayer?.isWhite) {
      return false;
    }
    if (!sourcePiece.isValidMove(board!, start, end)) {
      return false;
    }
    Piece? destPiece = end.piece;
    if (destPiece != null && destPiece.isWhite == currentPlayer?.isWhite) {
      return false;
    }
    // if (isBlocked(start, end, board!)) {
    //   return false;
    // }
    if (destPiece != null) {
      destPiece.isKilled = true;
      currentPlayer?.killedPieces.add(destPiece);
    }
    end.piece = start.piece;
    start.piece = null;

    if (currentPlayer == null) {
      return false;
    }

    if (sourcePiece is Pawn) {
      sourcePiece.isFirstMove = false;
    }

    if (destPiece is King) {
      if (currentPlayer!.isWhite) {
        status = GameStatus.whiteWin;
      } else {
        status = GameStatus.blackWin;
      }
    }
    if (status == GameStatus.active) {
      if (currentPlayer!.isWhite) {
        currentPlayer = players[1];
      } else {
        currentPlayer = players[0];
      }
    }
    return true;
  }
}
