

GAME_LOOP
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R0, SINGLE_PLAYER
    AND R1, R1, #0
    ADD R1, R0, #0
    BRp SINGLE_PLAYER_LOOP
    BRz TWO_PLAYER_LOOP

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

REF_LOG_PLAYER_1 .FILL LOG_PLAYER_1
REF_LOG_PLAYER_2 .FILL LOG_PLAYER_2
REF_LOG_PLAYER_AI .FILL LOG_PLAYER_AI
TWO_PLAYER_LOOP
    ; Player 1
    LD R0, REF_LOG_PLAYER_1
    PUTS
    LD R0, PLAYER
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED

    ; Player 2
    LD R0, REF_LOG_PLAYER_2
    PUTS
    LD R0, PLAYER_2
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED

    BR TWO_PLAYER_LOOP

SINGLE_PLAYER_LOOP
    ; Player 1
    LD R0, REF_LOG_PLAYER_1
    PUTS
    LD R0, PLAYER
    ST R0, CURRENT_PLAYER
    JSR PROCESS_PLAYER_MOVE
    JSR PRINT_GAMEBOARD
    ; Check Win
    JSR CHECK_WIN
    BRP LOG_WIN_OCCURED
    ; Check Tie
    JSR ALL_TILES_FILLED
    BRP LOG_TIE_OCCURED

    ; Log thinking
    LD R0, REF_LOG_PLAYER_AI
    PUTS
    JSR LOG_THINKING

    ; AI Player
    LD R0, AI
    ST R0, CURRENT_PLAYER
    JSR AI_PROCESS_MOVE
    JSR PRINT_GAMEBOARD
    ; Check Loss
    JSR CHECK_WIN
    BRP LOG_LOSS_OCCURED
    ; Check Tie
    JSR ALL_TILES_FILLED
    BRP LOG_TIE_OCCURED

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

RESET_GAME
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    AND R0, R0, #0
    ST R0, TILE_A1
    ST R0, TILE_A2
    ST R0, TILE_A3
    ST R0, TILE_B1
    ST R0, TILE_B2
    ST R0, TILE_B3
    ST R0, TILE_C1
    ST R0, TILE_C2
    ST R0, TILE_C3

    JSR PRINT_GAMEBOARD

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    BR GAME_LOOP

; REF_ variables are used to manage references to far away 
; strings so that we can overcome limitations with how 
; far away LC3 can access the program memory from.
; They store the memory location of the string that we want to use.

REF_LOG_BOT_2 .FILL LOG_BOT_2
REF_LOG_BOT_4 .FILL LOG_BOT_4
PRINT_WELCOME
    LD R0, REF_LOG_BOT_2
    PUTS
    LD R0, REF_LOG_BOT_4
    PUTS
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
    ; There is a bug where if Player 2 inputs an invalid input
    ; Then it will loop back to Player 1.
    ; It's 5am and I don't have time to properly fix this...
    BR GAME_LOOP

REF_LOG_ERROR_2 .FILL LOG_ERROR_2
INPUT_ERROR_TILE_NOT_AVAILABLE
    LD R0, REF_LOG_ERROR_2       ; Load the address of the error message
    PUTS                     ; Display the error message
    BR PROCESS_PLAYER_MOVE

REF_LOG_WIN .FILL LOG_WIN
LOG_WIN_OCCURED
    LD R0, REF_LOG_WIN
    PUTS
    JSR RESET_GAME

REF_LOG_LOSS .FILL LOG_LOSS
LOG_LOSS_OCCURED
    LD R0, REF_LOG_LOSS
    PUTS
    JSR RESET_GAME

REF_LOG_TIE .FILL LOG_TIE
LOG_TIE_OCCURED
    LD R0, REF_LOG_TIE
    PUTS
    JSR RESET_GAME
