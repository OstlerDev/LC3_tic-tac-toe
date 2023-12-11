; Tic Tac Toe program

; initialize variables

; print welcome message

; print current game-board to the console


; start game loop
MAIN
	JSR PROCESS_PLAYER_MOVE ; Get a move from the player
	LEA R0, TILE_B3         ; Load the address of TILE_A1 into R0
    JSR PRINT_TILE_ICON     ; Call the subroutine
HALT


; ask if the user would like to play another game
; end_of_game subroutine
	; Ask if user would like to 
