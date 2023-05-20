import 'package:chess2/captured_row.dart';
import 'package:flutter/material.dart';
import 'package:squares/squares.dart';
import 'controller.dart';
import 'util.dart';
import 'package:chess/chess.dart' as chess;

class ChessGame extends StatefulWidget {
  @override
  const ChessGame({Key? key}) : super(key: key);

  @override
  ChessGameState createState() => ChessGameState();
}

class ChessGameState extends State<ChessGame> {
  late chess.Chess game;
  String? selected;

  @override
  void initState() {
    super.initState();
    game = chess.Chess();
    selected = null;

    print(game.board.length);
  }

  String getSquare(int row, int col) {
    String rows = '12345678';
    String cols = 'abcdefgh';
    return '${cols[col]}${rows[row]}';
  }

  void move(String from, String to) {
    setState(() {
      game.move({'from': from, 'to': to});
    });
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
                              color: isWhite ? Colors.white : Colors.grey,
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
            Text(
                '${game.turn == chess.Color.WHITE ? 'White' : 'Black'} to move'),
          ],
        ),
      ),
    );
  }

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
}
