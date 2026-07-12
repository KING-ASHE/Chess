import 'package:flutter/material.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChessBoardScreen(),
    );
  }
}

class ChessBoardScreen extends StatefulWidget {
  const ChessBoardScreen({super.key});

  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Japana Chess", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1, // බෝඩ් එක Square (කොටුවක්) විදිහට තියාගන්න
          child: GridView.builder(
            itemCount: 64, // කොටු 64යි (8x8)
            physics: const NeverScrollableScrollPhysics(), // Scroll වෙන්න දීම වැළැක්වීම
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // පේළියකට කොටු 8යි
            ),
            itemBuilder: (context, index) {
              // කොටුවේ පේළිය (Row) සහ තීරුව (Column) හොයාගන්නා Logic එක
              int row = index ~/ 8;
              int col = index % 8;

              // කොටුවේ පාට තීරණය කිරීම (සුදු සහ කළු මාරුවෙන් මාරුවට)
              bool isLightSquare = (row + col) % 2 == 0;
              Color squareColor = isLightSquare ? const Color(0xFFF0D9B5) : const Color(0xB5B58863);

              return Container(
                color: squareColor,
                child: Center(
                  child: Text(
                    '$row,$col', 
                    style: TextStyle(
                      color: isLightSquare ? Colors.black26 : Colors.white24,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}