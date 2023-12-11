
; REF_ variables are used to manage references to far away 
; strings so that we can overcome limitations with how 
; far away LC3 can access the program memory from.
; They store the memory location of the string that we want to use.

PROCESS_PLAYER_MOVE
    JSR PRINT_INPUT_MOVE
    JSR GET_PLAYER_INPUT
    JSR VALIDATE_INPUT
    BR INPUT_ERROR ; Log and come back to process the input again ;; NOTE: This may cause dual inputs from a player if we have a deeper bug in our code

CONTINUE_PLAYER_MOVE
    JSR SELECT_TILE
    JSR CHECK_TILE
    ; Check if it was a valid tile, if not, branch off
    ; BRz TILE_TAKEN
    JSR SET_TILE
    RET

REF_LOG_INPUT_1 .FILL LOG_INPUT_1
PRINT_INPUT_MOVE
    LD R0, REF_LOG_INPUT_1   ; Load the address of the input prompt
    PUTS                     ; Display the prompt
    RET

REF_LOG_ERROR_1 .FILL LOG_ERROR_1
INPUT_ERROR
    LD R0, REF_LOG_ERROR_1   ; Load the address of the input prompt
    PUTS                     ; Display the prompt
    BR PROCESS_PLAYER_MOVE

REF_LOG_ERROR_2 .FILL LOG_ERROR_2
TILE_TAKEN
    LD R0, REF_LOG_ERROR_2       ; Load the address of the error message
    PUTS                     ; Display the error message
    RET



; player_loop

    ; get valid input from user

    ; update gameboard with the newly claimed tile

    ; check if player won

    ; branch to player_win, or branch to opponent loop

    ; print gameboard

; opponent_loop

    ; use ai-opponent to decide best move

    ; claim tile selected

    ; check for win states

    ; branch to player_loss, or branch back to player_loop to keep going
