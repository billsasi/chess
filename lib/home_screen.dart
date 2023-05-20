import 'package:flutter/material.dart';
import 'game.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess Game',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007FFF),
      appBar: AppBar(
        title: const Text('Chess Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 40.0),
            SizedBox(
              width: 350.0,
              height: 100.0,
              child: Container(
                width: 120.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC000),
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                ),
                child: Center(
                  child: Text(
                    'Chess',
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 350.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChessGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90EE90),
                minimumSize: const Size(300.0, 80.0),
              ),
              child: const Text(
                'Play',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BotSelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90EE90),
                minimumSize: const Size(300.0, 80.0),
              ),
              child: const Text(
                'Bot Battle',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BotSelectionScreen extends StatelessWidget {
  const BotSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF007FFF),
      appBar: AppBar(
        title: const Text('Select bot difficulty'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChessGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90EE90),
                minimumSize: const Size(300.0, 80.0),
              ),
              child: const Text(
                'Easy',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChessGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90EE90),
                minimumSize: const Size(300.0, 80.0),
              ),
              child: const Text(
                'Medium',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChessGame()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF90EE90),
                minimumSize: const Size(300.0, 80.0),
              ),
              child: const Text(
                'Hard',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Back',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
