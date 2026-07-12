import 'package:flutter/material.dart';
// 🎯 1. මුලින්ම ලයිබ්‍රරි එක උඩින්ම ඉම්පෝට් කරගන්නවා
import 'package:chess/chess.dart' as chess; // 🎯 ඩොට් ඩාර්ට් (.dart) අනිවාර්යයි

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
  // 🎯 2. අපේ පරණ 2D String List එක වෙනුවට කෙලින්ම ලයිබ්‍රරියේ චෙස් ඔබ්ජෙක්ට් එකක් ගන්නවා
  late chess.Chess game;

  int selectedRow = -1;
  int selectedCol = -1;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    // 🎯 3. අලුත් චෙස් ක්‍රීඩාවක් ආරම්භ කිරීම (මෙයා ඔටෝමැටිකව බෝඩ් එක සෙට් කරගන්නවා)
    game = chess.Chess();
    selectedRow = -1;
    selectedCol = -1;
  }

  // කොටු වල index coordinates (0,0) සිට (7,7) දක්වා චෙස් වල සාමාන්‍ย කොටු නාම (a1 සිට h8) වලට හැරවීම
  String _getSquareName(int row, int col) {
    List<String> columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    // චෙස් වල 8 වෙනි පේළිය තියෙන්නේ උඩින්ම නිසා (8 - row) ලෙස ගන්නවා
    return '${columns[col]}${8 - row}';
  }

  // 🕹️ කොටුවක් ක්ලික් කළ විට ක්‍රියාත්මක වන ප්‍රධාන මෙතඩය
  void _handleSquareTap(int row, int col) {
    String clickedSquare = _getSquareName(row, col);
    var pieceOnClickedSquare = game.get(clickedSquare);

    setState(() {
      // කෑල්ලක් දැනටමත් සිලෙක්ට් වෙලා තියෙනවා නම් (Move එකක් කරන්න හදන්නේ)
      if (selectedRow != -1 && selectedCol != -1) {
        String fromSquare = _getSquareName(selectedRow, selectedCol);

        // 🎯 4. ලයිබ්‍රරිය හරහා මේ මූව් එක නීත්‍යානුකූලද කියා බලා එය සිදු කිරීම
        bool moveSuccessful = game.move({
          'from': fromSquare,
          'to': clickedSquare,
          'promotion':
              'q', // ඉත්තෙක් අන්තිම කොටුවට ගියොත් ඔටෝමැටිකව රැජිනක් (Queen) බවට පත් කිරීම
        });

        if (!moveSuccessful) {
          // වැරදි මූව් එකක් නම් Notification එකක් පෙන්වීම
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Move! නිවැරදි චෙස් මූව් එකක් අදින්න.'),
              duration: Duration(milliseconds: 600),
            ),
          );
        }

        // Selection එක clear කිරීම
        selectedRow = -1;
        selectedCol = -1;

        // 🎯 5. ගේම් එක ඉවරද (Checkmate) කියා පරික්ෂා කිරීම
        // 🎯 අලුත් කෝඩ් එක (වරහන් රහිතව):
        if (game.in_checkmate) {
          _showGameOverDialog("Checkmate! Game Over.");
        } else if (game.in_draw) {
          _showGameOverDialog("Draw! සම සමව ගේම් එක ඉවරයි.");
        }
      } else {
        // තවම කෑල්ලක් සිලෙක්ට් කරලා නැත්නම් සහ ක්ලික් කරපු කොටුවේ වාරය හිමි ප්ලේයර්ගේ කෑල්ලක් තියෙනවා නම්
        if (pieceOnClickedSquare != null) {
          // තමන්ගේ වාරයේදී තමන්ගේ පාට කෑල්ලක් විතරක් සිලෙක්ට් කිරීමට ඉඩ දීම
          if ((game.turn == chess.Color.WHITE &&
                  pieceOnClickedSquare.color == chess.Color.WHITE) ||
              (game.turn == chess.Color.BLACK &&
                  pieceOnClickedSquare.color == chess.Color.BLACK)) {
            selectedRow = row;
            selectedCol = col;
          }
        }
      }
    });
  }

  // UI එකට අදාළ චෙස් සිම්බල් එක ලබාගැනීම
  String _getPieceSymbol(chess.Piece? piece) {
    if (piece == null) return '';

    // කෙලින්ම ලයිබ්‍රරියේ එන piece type එක අනුව සිම්බල් එක දීම
    switch (piece.type.toUpperCase()) {
      case 'R':
        return '♜';
      case 'N':
        return '♞';
      case 'B':
        return '♝';
      case 'Q':
        return '♛';
      case 'K':
        return '♚';
      case 'P':
        return '♟';
      default:
        return '';
    }
  }

  // කෑල්ලේ පාට තීරණය කිරීම
  Color _getPieceColor(chess.Piece? piece) {
    if (piece == null) return Colors.transparent;
    return piece.color == chess.Color.WHITE ? Colors.black : Colors.white;
  }

  void _showGameOverDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("เกม Over!"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("Reset Game"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _resetGame());
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          game.turn == chess.Color.WHITE
              ? "Japana Chess (White's Turn)"
              : "Japana Chess (Black's Turn)",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() => _resetGame()),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          constraints: const BoxConstraints(maxWidth: 500),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[800]!, width: 5),
              ),
              child: GridView.builder(
                itemCount: 64,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 8;
                  int col = index % 8;

                  bool isSelected = (row == selectedRow && col == selectedCol);
                  bool isLightSquare = (row + col) % 2 == 0;
                  Color squareColor = isLightSquare
                      ? const Color(0xFFF0D9B5)
                      : const Color(0xFFB58863);

                  if (isSelected) {
                    squareColor = Colors.green.withOpacity(0.8);
                  }

                  // 🎯 6. ලයිබ්‍රරියෙන් ඒ කොටුවේ දැනට ඉන්න කෑල්ල කියවා ගැනීම
                  String squareName = _getSquareName(row, col);
                  var piece = game.get(squareName);

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
