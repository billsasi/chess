import 'package:chess2/captured_row.dart';
import 'package:flutter/material.dart';
import 'controller.dart';
import 'util.dart';

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
            Text('Game Status: ${game.status}'),
            CapturedRow(game.players[1].killedPieces),
            const SizedBox(height: 16.0),
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
                                  getPieceImageAsset(piece),
                                  width: 32.0,
                                  height: 32.0,
                                ),
                        ),
                        onDragStarted: () {
                          print('drag started');
                          if (piece == null) {
                            return;
                          }
                          print('selectedSpot: $selectedSpot');
                          setState(() {
                            selectedSpot = spot;
                          });
                          print('selectedSpot: $selectedSpot');
                        },
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
                                      getPieceImageAsset(piece),
                                      width: 32.0,
                                      height: 32.0,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                    onWillAccept: (Spot? spot1) {
                      print('onWillAccept');
                      print('selectedSpot: $selectedSpot');
                      print('spot: ${spot?.x}, ${spot?.y}');
                      return selectedSpot != null &&
                          selectedSpot!.piece!
                              .isValidMove(board!, selectedSpot!, spot!);
                    },
                    onAccept: (Spot? spot1) {
                      print('onAccept');
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
            ),
            const SizedBox(height: 16.0),
            CapturedRow(game.players[0].killedPieces),
            Text(game.currentPlayer?.name ?? ''),
          ],
        ),
      ),
    );
  }
}
