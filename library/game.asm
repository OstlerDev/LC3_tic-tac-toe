

GAME_LOOP
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR SINGLE_PLAYER_LOOP
    ; JSR TWO_PLAYER_LOOP

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
    BRP LOG_WIN_OCCURED

    ; Player 2
    LD R0, PLAYER_2
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED

    BR TWO_PLAYER_LOOP

SINGLE_PLAYER_LOOP
    ; Player 1
    LD R0, PLAYER
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED

    ; AI Player
    LD R0, AI
    ST R0, CURRENT_PLAYER
    JSR AI_PROCESS_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED

    BR SINGLE_PLAYER_LOOP

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
    JSR CLAIM_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

CLAIM_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Claim the untaken tile for our player
    LD R0, CURRENT_PLAYER
    JSR SET_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

WIN_OCCURED
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R0, R0, #0
    ADD R0, R0, #1   ; Leave a positive op as the last on the stack
    RET

CHECK_WIN
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R0, CURRENT_PLAYER

    ; Row A
    LD R1, TILE_A1
    LD R2, TILE_A2
    LD R3, TILE_A3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    ; Row B
    LD R1, TILE_B1
    LD R2, TILE_B2
    LD R3, TILE_B3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    ; Row C
    LD R1, TILE_C1
    LD R2, TILE_C2
    LD R3, TILE_C3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED

    ; Col 1
    LD R1, TILE_A1
    LD R2, TILE_B1
    LD R3, TILE_C1
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    ; Col 2
    LD R1, TILE_A2
    LD R2, TILE_B2
    LD R3, TILE_C2
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    ; Col 3
    LD R1, TILE_A3
    LD R2, TILE_B3
    LD R3, TILE_C3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED

    ; diagonal 1
    LD R1, TILE_A1
    LD R2, TILE_B2
    LD R3, TILE_C3
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    ; diagonal 2
    LD R1, TILE_A3
    LD R2, TILE_B2
    LD R3, TILE_C1
    JSR CHECK_MATCHING
    BRP WIN_OCCURED
    
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R0, R0, #0
    ADD R0, R0, #0   ; Leave a zero op as the last on the stack
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
LOG_WIN_OCCURED
    LD R0, REF_LOG_WIN
    PUTS
    HALT
