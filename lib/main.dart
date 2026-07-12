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
  late List<List<String>> boardState;

  // 🎯 Select කරපු කොටුවේ තොරතුරු තබා ගැනීමට (මුලින්ම මුකුත් select වෙලා නැහැ = -1)
  int selectedRow = -1;
  int selectedCol = -1;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    boardState = [
      ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'],
      ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
      ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
    ];
    selectedRow = -1;
    selectedCol = -1;
  }

  // 🕹️ කොටුවක් ක්ලික් කළාම වැඩ කරන ප්‍රධාන Function එක
  void _handleSquareTap(int row, int col) {
    setState(() {
      // 1. දැනටමත් කෑල්ලක් select වෙලා තියෙනවා නම් (අලුත් තැනකට අදින්න හදන්නේ)
      if (selectedRow != -1 && selectedCol != -1) {
        // ක්ලික් කළේ දැනටමත් select වෙලා තියෙන කොටුවම නම්, selection එක අයින් කරන්න
        if (selectedRow == row && selectedCol == col) {
          selectedRow = -1;
          selectedCol = -1;
        } else {
          // 🔄 කෑල්ල අලුත් කොටුවට මාරු කිරීම (Move Piece)
          boardState[row][col] = boardState[selectedRow][selectedCol];
          boardState[selectedRow][selectedCol] = ''; // කලින් තිබ්බ තැන හිස් කිරීම
          
          // Selection එක clear කිරීම
          selectedRow = -1;
          selectedCol = -1;
        }
      } 
      // 2. තවම කෑල්ලක් select වෙලා නැත්නම් සහ ක්ලික් කරපු කොටුවේ කෑල්ලක් තියෙනවා නම්
      else if (boardState[row][col].isNotEmpty) {
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  String _getPieceSymbol(String piece) {
    switch (piece) {
      case 'R': return '♜';
      case 'N': return '♞';
      case 'B': return '♝';
      case 'Q': return '♛';
      case 'K': return '♚';
      case 'P': return '♟';
      case 'r': return '♖';
      case 'n': return '♘';
      case 'b': return '♗';
      case 'q': return '♕';
      case 'k': return '♔';
      case 'p': return '♙';
      default: return '';
    }
  }

  Color _getPieceColor(String piece) {
    if (piece.isEmpty) return Colors.transparent;
    return piece == piece.toUpperCase() ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Japana Chess", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() => _resetBoard()), // Reset බටන් එක
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(maxWidth: 500),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey[800]!, width: 5)),
              child: GridView.builder(
                itemCount: 64,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

                  // 🎨 කොටුව Select වෙලාද බලන්න
                  bool isSelected = (row == selectedRow && col == selectedCol);

                  bool isLightSquare = (row + col) % 2 == 0;
                  Color squareColor = isLightSquare ? const Color(0xFFF0D9B5) : const Color(0xFFB58863);

                  // කෑල්ලක් select කළාම ඒ කොටුව Highlight (කොළ පාට) කරන්න
                  if (isSelected) {
                    squareColor = Colors.green.withOpacity(0.8);
                  }

                  String piece = boardState[row][col];

                  // 👆 කොටුව ක්ලික් කිරීම හසුකර ගැනීමට GestureDetector එකක් දමා ඇත
                  return GestureDetector(
                    onTap: () => _handleSquareTap(row, col),
                    child: Container(
                      color: squareColor,
                      child: Center(
                        child: Text(
                          _getPieceSymbol(piece),
                          style: TextStyle(
                            fontSize: 35,
                            color: _getPieceColor(piece),
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
    );
  }
}