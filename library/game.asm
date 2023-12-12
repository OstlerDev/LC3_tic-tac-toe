

PROCESS_PLAYER_MOVE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Get input
    JSR PRINT_INPUT_MOVE
    JSR GET_PLAYER_INPUT
    ; Validate text input
    JSR VALIDATE_INPUT
    ; Check if tile is already taken
    JSR SELECT_TILE
    JSR CHECK_TILE_PLAYER
    ; Claim the untaken tile for our player
    LD R0, PLAYER
    JSR SET_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET


; REF_ variables are used to manage references to far away 
; strings so that we can overcome limitations with how 
; far away LC3 can access the program memory from.
; They store the memory location of the string that we want to use.

; TODO, manage stack in errors so we properly can loop back up to main.
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
INPUT_ERROR_TILE_NOT_AVAILABLE
    LD R0, REF_LOG_ERROR_2       ; Load the address of the error message
    PUTS                     ; Display the error message
    BR PROCESS_PLAYER_MOVE



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
