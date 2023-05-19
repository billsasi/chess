import 'package:flutter/material.dart';
import 'controller.dart';

class ChessGame extends StatefulWidget {
  @override
  const ChessGame({Key? key}) : super(key: key);

  @override
  ChessGameState createState() => ChessGameState();
}

class ChessGameState extends State<ChessGame> {
  late final Game game;
  Board? get board => game.board;
  Spot? selectedSpot;

  @override
  void initState() {
    super.initState();

    final whitePlayer = Player(true, 'White Player');
    final blackPlayer = Player(false, 'Black Player');
    game = Game([whitePlayer, blackPlayer]);
    game.startGame(whitePlayer, blackPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 64,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (BuildContext context, int index) {
                final int row = (8 - (index ~/ 8)).abs() - 1;
                final int col = index % 8;
                final bool isWhite = (row + col) % 2 != 0;
                final spot = board?.spots[row][col];
                final piece = spot?.piece;
                final bool reachable = selectedSpot != null &&
                    selectedSpot!.piece!
                        .isValidMove(board!, selectedSpot!, spot!);
                return DragTarget<Spot>(
                  builder: (BuildContext context, List<dynamic> candidateData,
                      List<dynamic> rejectedData) {
                    return Draggable<Spot>(
                      feedback: Container(
                        child: piece == null
                            ? null
                            : Image.asset(
                                _getPieceImageAsset(piece),
                                width: 32.0,
                                height: 32.0,
                              ),
                      ),
                      childWhenDragging: Container(),
                      data: spot,
                      child: GestureDetector(
                        onTap: () {
                          final start = selectedSpot;
                          final end = spot;

                          if (selectedSpot == null && piece != null) {
                            setState(() {
                              selectedSpot = spot;
                            });
                            return;
                          }

                          if (start != null && end != null) {
                            if (game.playerMove(start, end)) {}
                            setState(() => selectedSpot = null);
                          }
                        },
                        child: Container(
                          color: reachable
                              ? Color.fromARGB(255, 166, 255, 102)
                              : isWhite
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : Color.fromARGB(255, 133, 223, 243),
                          child: Center(
                            child: piece == null
                                ? null
                                : Image.asset(
                                    _getPieceImageAsset(piece),
                                    width: 32.0,
                                    height: 32.0,
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                  onWillAccept: (Spot? spot) {
                    return selectedSpot != null &&
                        selectedSpot!.piece!
                            .isValidMove(board!, selectedSpot!, spot!);
                  },
                  onAccept: (Spot? spot) {
                    final start = selectedSpot;
                    final end = spot;

                    if (start != null && end != null) {
                      if (game.playerMove(start, end)) {}
                      setState(() => selectedSpot = null);
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: game.players[0].killedPieces.map((item) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Center(
                    child: Text(
                      _getPieceImageAsset(item),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Text(game.currentPlayer?.name ?? ''),
          ],
        ),
      ),
    );
  }
}

String _getPieceImageAsset(Piece piece) {
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

String _getPieceUnicode(Piece piece) {
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
