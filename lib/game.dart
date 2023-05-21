import 'package:chess2/captured_row.dart';
import 'package:flutter/material.dart';
import 'util.dart';
import 'package:chess/chess.dart' as chess;
import 'ai.dart';

enum GameMode { twoPlayer, botEasy, botMed, botHard }

class ChessGame extends StatefulWidget {
  final GameMode gameMode;

  @override
  const ChessGame({required this.gameMode, Key? key}) : super(key: key);

  @override
  ChessGameState createState() => ChessGameState();
}

class ChessGameState extends State<ChessGame> {
  late chess.Chess game;
  String? selected;
  List<chess.Piece> whiteCaputuredPieces = [];
  List<chess.Piece> blackCaputuredPieces = [];

  @override
  void initState() {
    super.initState();
    game = chess.Chess();
    selected = null;
  }

  String getSquare(int row, int col) {
    String rows = '12345678';
    String cols = 'abcdefgh';
    return '${cols[col]}${rows[row]}';
  }

  void botMove() {
    String to = "";
    chess.Move? next;
    if (widget.gameMode == GameMode.botEasy) {
      var moves = game.moves();
      moves.shuffle();
      to = moves[0];
    } else if (widget.gameMode == GameMode.botHard) {
      print('Bot thinking...');
      next = findBestMove(game);

      if (next!.piece == chess.PieceType.PAWN) {
        to = next!.toAlgebraic;
      }

      final piece = pieceToAscii(next!.piece);
      final square = next!.toAlgebraic;

      to = "$piece$square";
    }
    print('Bot done thinking...');

    var dest = to.substring(to.length - 2);

    // capture piece
    if (game.get(dest) != null) {
      if (game.get(dest)!.color == chess.Color.WHITE) {
        whiteCaputuredPieces.add(game.get(dest)!);
      } else {
        blackCaputuredPieces.add(game.get(dest)!);
      }
    }

    print('move: ${to}');

    if (game.get(dest) != null) {
      to = to.substring(0, to.length - 2) + 'x' + to.substring(to.length - 2);
    }

    bool moveSuccess = false;

    if (next != null) {
      String from = next.fromAlgebraic;
      to = next.toAlgebraic;
      moveSuccess = game.move({'from': from, 'to': to});
      print('move success: $moveSuccess');
    } else {
      moveSuccess = game.move(to);
    }
    setState(() {});

    print('im here');

    String winner = game.turn == chess.Color.WHITE ? 'Black' : 'White';

    if (game.in_checkmate) {
      showGameOverDialog(context, 'Checkmate!', winner: winner);
    } else if (game.in_stalemate) {
      showGameOverDialog(context, 'Stalemate');
    } else if (game.in_draw) {
      showGameOverDialog(context, 'Draw');
    }
  }

  void move(String? from, String to) {
    to = to.substring(to.length - 2);
    // capture piece
    if (game.get(to) != null) {
      if (game.get(to)!.color == chess.Color.WHITE) {
        whiteCaputuredPieces.add(game.get(to)!);
      } else {
        blackCaputuredPieces.add(game.get(to)!);
      }
    }

    setState(() {
      if (from == null) {
        game.move(to);
      } else {
        game.move({'from': from, 'to': to});
      }
    });

    String winner = game.turn == chess.Color.WHITE ? 'Black' : 'White';

    if (game.in_checkmate) {
      showGameOverDialog(context, 'Checkmate!', winner: winner);
    } else if (game.in_stalemate) {
      showGameOverDialog(context, 'Stalemate');
    } else if (game.in_draw) {
      showGameOverDialog(context, 'Draw');
    }

    if (game.turn == chess.Color.BLACK &&
        widget.gameMode != GameMode.twoPlayer) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        botMove();
      });
    }
  }

  void showGameOverDialog(BuildContext context, String message,
      {String? winner}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: winner != null
              ? const Text('Checkmate!')
              : const Text('Game Over'),
          content: winner != null ? Text('$winner wins') : Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF007FFF),
      appBar: AppBar(
        title: const Text('Chess'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CapturedRow(whiteCaputuredPieces),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: GridView.builder(
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
                  int i = index + (index ~/ 8) * 8;
                  String square = getSquare(row, col);
                  bool reachable = false;
                  chess.Piece? piece = game.get(square);

                  if (selected != null) {
                    reachable = game
                        .moves({'square': selected, 'verbose': true}).any(
                            (move) => move['to'] == square);
                  }

                  return DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                    return Draggable(
                        dragAnchorStrategy: childDragAnchorStrategy,
                        feedback: Container(
                          child: piece == null
                              ? null
                              : Image.asset(getPieceImageAsset(piece),
                                  width: 40, height: 40),
                        ),
                        onDragStarted: () {
                          if (piece != null &&
                              piece.color == game.turn &&
                              game.moves({
                                'square': square,
                                'verbose': true
                              }).isNotEmpty) {
                            setState(() {
                              selected = square;
                            });
                          }
                        },
                        childWhenDragging: Container(),
                        data: square,
                        child: GestureDetector(
                          onTap: () {
                            print('selected: $selected ${getSquare(row, col)}');

                            if (selected == null && piece != null) {
                              setState(() {
                                selected = square;
                              });
                              return;
                            }

                            if (selected != null) {
                              move(selected!, square);
                              setState(() => selected = null);
                            }
                          },
                          child: Container(
                              color: isWhite
                                  ? Colors.white
                                  : Color.fromARGB(255, 130, 147, 165),
                              child: Stack(
                                children: [
                                  if (reachable)
                                    Container(
                                      color: Colors.green.withOpacity(0.5),
                                    ),
                                  if (game.get(square) != null)
                                    Center(
                                      child: Image.asset(
                                        getPieceImageAsset(game.get(square)!),
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ),
                                ],
                              )),
                        ));
                  }, onWillAccept: (data) {
                    var res = game
                        .moves({'square': selected, 'verbose': true}).any(
                            (move) => move['to'] == square);
                    print('onWillAccept: $res');
                    print('data: $data');
                    return res;
                  }, onAccept: (data) {
                    print('onAccept: $selected ${square}');
                    if (selected == null) {
                      return;
                    }
                    move(selected!, square);
                    selected = null;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            CapturedRow(blackCaputuredPieces),
            const SizedBox(height: 30),
            Text(
              widget.gameMode == GameMode.twoPlayer
                  ? '${game.turn == chess.Color.WHITE ? 'White' : 'Black'} to move'
                  : game.turn == chess.Color.WHITE
                      ? 'Your turn (white)'
                      : 'Bot is thinking...',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
