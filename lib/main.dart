import 'package:chess/controller.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Chess',
    home: ChessGame(),
  ));
}

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
        title: Text('Chess'),
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
                return GestureDetector(
                    onTap: () {
                      final start = selectedSpot;
                      final end = board?.spots[row][col];

                      if (selectedSpot == null) {
                        setState(() {
                          selectedSpot = spot;
                        });
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
                              ? const Color.fromARGB(255, 220, 220, 220)
                              : const Color.fromARGB(255, 86, 86, 86),
                      child: Center(
                        child: piece == null
                            ? null
                            : Text(
                                _getPieceUnicode(piece),
                                style: TextStyle(
                                  fontSize: 32.0,
                                  color: piece.isWhite
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                      ),
                    ));
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
                      _getPieceUnicode(item),
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

String _getPieceUnicode(Piece piece) {
  if (piece is King) {
    return piece.isWhite ? '♔' : '♚';
  } else if (piece is Queen) {
    return piece.isWhite ? '♕' : '♛';
  } else if (piece is Rook) {
    return piece.isWhite ? '♖' : '♜';
  } else if (piece is Bishop) {
    return piece.isWhite ? '♗' : '♝';
  } else if (piece is Knight) {
    return piece.isWhite ? '♘' : '♞';
  } else if (piece is Pawn) {
    return piece.isWhite ? '♙' : '♟︎';
  } else {
    return '';
  }
}
