import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage()));
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  // Define the board size and the symbols for the players
  static const int boardSize = 3;
  static const String playerX = 'X';
  static const String playerO = 'O';

  // Initialize the board as a list of empty strings
  List<String> board = List.filled(boardSize * boardSize, '');

  // Keep track of the current player and the game state
  String currentPlayer = playerX;
  String winner = '';
  bool isDraw = false;

  // Check if the board is full
  bool isBoardFull() {
    return board.every((element) => element.isNotEmpty);
  }

  // Check if a player has won by forming a line horizontally, vertically or diagonally
  bool hasWon(String player) {
    // Check horizontal lines
    for (int i = 0; i < boardSize; i++) {
      bool isLine = true;
      for (int j = 0; j < boardSize; j++) {
        if (board[i * boardSize + j] != player) {
          isLine = false;
          break;
        }
      }
      if (isLine) return true;
    }
    // Check vertical lines
    for (int i = 0; i < boardSize; i++) {
      bool isLine = true;
      for (int j = 0; j < boardSize; j++) {
        if (board[j * boardSize + i] != player) {
          isLine = false;
          break;
        }
      }
      if (isLine) return true;
    }
    // Check diagonal lines
    bool isDiagonal1 = true;
    bool isDiagonal2 = true;
    for (int i = 0; i < boardSize; i++) {
      if (board[i * boardSize + i] != player) {
        isDiagonal1 = false;
      }
      if (board[i * boardSize + (boardSize - i - 1)] != player) {
        isDiagonal2 = false;
      }
    }
    return isDiagonal1 || isDiagonal2;
  }

  // Handle the user tapping on a cell of the board
  void handleTap(int index) {
    // If the cell is already filled or the game is over, do nothing
    if (board[index].isNotEmpty || winner.isNotEmpty || isDraw) return;
    // Otherwise, fill the cell with the current player's symbol and update the state
    setState(() {
      board[index] = currentPlayer;
      if (hasWon(currentPlayer)) {
        winner = currentPlayer;
      } else if (isBoardFull()) {
        isDraw = true;
      } else {
        currentPlayer = currentPlayer == playerX ? playerO : playerX;
      }
    });
  }

  // Reset the game state and clear the board
  void resetGame() {
    setState(() {
      board = List.filled(boardSize * boardSize, '');
      currentPlayer = playerX;
      winner = '';
      isDraw = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic-Tac-Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display a message with the game status
          Text(
            winner.isNotEmpty
                ? '$winner won!'
                : isDraw
                    ? 'It\'s a draw!'
                    : 'It\'s $currentPlayer\'s turn',
            style: TextStyle(fontSize: 32),
          ),

          Expanded(
            child: SingleChildScrollView(
              child:

                  // Display the board as a grid of buttons
                  GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: boardSize,
                ),
                itemCount: board.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(fontSize: 64),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Display a button to reset the game
          ElevatedButton(
            onPressed: resetGame,
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
