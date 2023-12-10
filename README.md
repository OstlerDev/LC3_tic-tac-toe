# LC-3 Tic-Tac-Toe
## Overview
This LC-3 Tic-Tac-Toe program is an implementation of the classic game Tic-Tac-Toe, where two players (one human and one AI) take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner. This program is designed to run on the LC-3 simulator, providing an interactive and engaging experience.

## Gameplay Features
- Interactive input system for selecting grid positions.
- Real-time updating of the gameboard after each move.
- Intelligent AI opponent with a variety of strategies.
- Checks for win, loss, and tie conditions.
- Option to replay after a game concludes.

## Running the Program
1. Run `./build.sh` to compile all files into one.
2. Load `main-all.asm` into the LC-3 simulator
3. Compile and run in LC3Tools
4. Follow the on-screen instructions to play the game.

## How to Play
Players make moves by selecting a row (A, B, C) and a column (1, 2, 3). For example, to select the top-right cell, the player would input "A3". The game alternates between the human player and the AI opponent, updating the gameboard after each turn.

## File Structure

### main_subroutine.asm
Initializes variables and prints the welcome message.
Manages the main game loop and end-of-game queries.

### game.asm
player_loop: Manages the human player's turn, including input validation, updating the gameboard, checking for win conditions, and alternating between players.
opponent_loop: Manages the AI opponent's turn, using a pseudo-random decision-making process to play.

### gameboard.asm
Manages the gameboard, which is stored across three registers for the player, opponent, and taken tiles.
Provides functionality for printing the gameboard, checking tile states, claiming tiles, and checking for win/tie conditions.

### ai-opponent.asm
Implements the AI logic for the opponent, using a combination of strategies such as blocking the human player's win, winning moves, and selecting strategic positions.