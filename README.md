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
1. Run `./compile.sh` to compile all files into one.
2. Load `MAIN_run-me.asm` into the LC-3 simulator
3. Compile and run in LC3Tools
4. Follow the on-screen instructions to play the game.

## Running via Terminal
1. Clone (LC-3 Tools GitHub repo)[] onto your machine
2. (Build/Compile the LC3-Tools binaries using these instructions)[https://github.com/chiragsakhuja/lc3tools/blob/master/docs/BUILD.md]
3. Go into the `build/bin` (`cd bin`) folder and rename a couple files
    a. `mv assembler lc3-assembler`
    b. `mv simulator lc3-simulator`
4. Modify the path to your lc3tools binary folder inside `run_terminal.sh`
5. Run the program using `./run_terminal.sh`

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