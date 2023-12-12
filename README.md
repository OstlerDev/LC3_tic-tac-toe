# LC-3 Tic-Tac-Toe
## Overview
This LC-3 Tic-Tac-Toe program is an implementation of the classic game Tic-Tac-Toe, where two players (one human and one AI) take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner. This program is designed to run on the LC-3 simulator, providing an interactive and engaging experience.

## How to Play
Players make moves by selecting a row (A, B, C) and a column (1, 2, 3). For example, to select the top-right cell, the player would input "A3". The game alternates between the human player and the AI opponent, updating the gameboard after each turn.

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

## Example Game Output
```
Hello,
Would you like to play a game of Tic-Tac-Toe?

Enter 1 for one-player mode, 2 for two-player mode: 1

     1   2   3  

 A     │   │    
    ───┼───┼─── 
 B     │   │    
    ───┼───┼─── 
 C     │   │    

Player 1: What space would you like to claim?
A1
     1   2   3  

 A   X │   │    
    ───┼───┼─── 
 B     │   │    
    ───┼───┼─── 
 C     │   │    

AI Player: * you can hear someone quietly typing behind a curtain to your right *
B2
     1   2   3  

 A   X │   │    
    ───┼───┼─── 
 B     │ ∞ │    
    ───┼───┼─── 
 C     │   │    

Player 1: What space would you like to claim?
C3
     1   2   3  

 A   X │   │    
    ───┼───┼─── 
 B     │ ∞ │    
    ───┼───┼─── 
 C     │   │ X  

AI Player: *beep-boop* *scratch-head* *ponder*
A3
     1   2   3  

 A   X │   │ ∞  
    ───┼───┼─── 
 B     │ ∞ │    
    ───┼───┼─── 
 C     │   │ X  

Player 1: What space would you like to claim?
C1
     1   2   3  

 A   X │   │ ∞  
    ───┼───┼─── 
 B     │ ∞ │    
    ───┼───┼─── 
 C   X │   │ X  

AI Player: *peek-behind-curtain* *whisper-to-invisible-advisor* *nod-earnestly*
B1
     1   2   3  

 A   X │   │ ∞  
    ───┼───┼─── 
 B   ∞ │ ∞ │    
    ───┼───┼─── 
 C   X │   │ X  

Player 1: What space would you like to claim?
C2
     1   2   3  

 A   X │   │ ∞  
    ───┼───┼─── 
 B   ∞ │ ∞ │    
    ───┼───┼─── 
 C   X │ X │ X  


 You Won! You have bested me, care to push your luck...? 


     1   2   3  

 A     │   │    
    ───┼───┼─── 
 B     │   │    
    ───┼───┼─── 
 C     │   │    

Player 1: What space would you like to claim?
V
That is not a valid input, please select a Row and Column using the Letter and Numbers for each column.
Here are some example inputs:
A3
C1
B2

Player 1: What space would you like to claim?
B2
     1   2   3  

 A     │   │    
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C     │   │    

AI Player: *shuffle-cards* *peeks-at-hand* shuffles-again*
A1
     1   2   3  

 A   ∞ │   │    
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C     │   │    

Player 1: What space would you like to claim?
V
That is not a valid input, please select a Row and Column using the Letter and Numbers for each column.
Here are some example inputs:
A3
C1
B2

Player 1: What space would you like to claim?
C1
     1   2   3  

 A   ∞ │   │    
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C   X │   │    

AI Player: *sneak-behind-curtain* *muffled-conversation* *reappear-with-confidence*
A3
     1   2   3  

 A   ∞ │   │ ∞  
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C   X │   │    

Player 1: What space would you like to claim?
C3
     1   2   3  

 A   ∞ │   │ ∞  
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C   X │   │ X  

AI Player: *tap-dance* *spin* *freeze-in-pose*
A2
     1   2   3  

 A   ∞ │ ∞ │ ∞  
    ───┼───┼─── 
 B     │ X │    
    ───┼───┼─── 
 C   X │   │ X  


 You LOST, better luck next time!  
```