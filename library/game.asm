

GAME_LOOP
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR TWO_PLAYER_LOOP

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

TWO_PLAYER_LOOP
    ; Player 1
    LD R0, PLAYER
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN

    ; Player 2
    LD R0, PLAYER_2
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN

    BR TWO_PLAYER_LOOP

; Expects player to be passed in as variable CURRENT_PLAYER
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
    LD R0, CURRENT_PLAYER
    JSR SET_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

CHECK_WIN
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R0, CURRENT_PLAYER
    LD R1, TILE_A1
    LD R2, TILE_A2
    LD R3, TILE_A3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    AND R1, R1, #0
    ADD R1, R1, #0
    
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

REF_LOG_WIN .FILL LOG_WIN
WIN_OCCURED
    LD R0, REF_LOG_WIN
    PUTS
    HALT
