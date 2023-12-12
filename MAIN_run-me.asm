.ORIG x3000
LD R6, STACK_PTR
JSR MAIN  ; Jump to main subroutine immediately, by passing needing to step through each instruction
STACK_PTR .FILL xFDFF
; VARIABLES
;
; Input variables
SINGLE_PLAYER .FILL #0

PLAYER_ROW    .BLKW 1    ; Raw input for player row    (ASCII)
PLAYER_COLUMN .BLKW 1    ; Raw input for player column (ASCII)

SELECTED_ROW .FILL #0      ; Latest inputed row number
SELECTED_COLUMN .FILL #0  ; Latest inputed column number

SELECTED_TILE_ADDR .FILL #0 ; The tile address that the Player/AI selected to place a tile

CURRENT_PLAYER  .FILL #0
PREVIOUS_VALUE  .FILL #0
PLAYER_TO_CHECK .FILL #0

; Gameboard tiles
; Each tile can be 0 (empty), 1 (player 1), or 2 (player 2/AI)
TILE_A1 .FILL #0
TILE_A2 .FILL #0
TILE_A3 .FILL #0
TILE_B1 .FILL #0
TILE_B2 .FILL #0
TILE_B3 .FILL #0
TILE_C1 .FILL #0
TILE_C2 .FILL #0
TILE_C3 .FILL #0
; Helper Variable
TEMP_ADDR .FILL #0    ; Temporary storage for loading registers easily

; CONSTANTS
;
; Game Constants
EMPTY     .FILL #0
PLAYER    .FILL #1
PLAYER_2  .FILL #2
AI        .FILL #3
; Output Constants
EMPTY_ICON    .STRINGZ " "
PLAYER_ICON   .STRINGZ "X"
PLAYER_2_ICON .STRINGZ "O"
AI_ICON       .STRINGZ "∞"
; Input constants
ROW_A   .STRINGZ "A"
ROW_B   .STRINGZ "B"
ROW_C   .STRINGZ "C"
COL_1   .STRINGZ "1"
COL_2   .STRINGZ "2"
COL_3   .STRINGZ "3"



; Main starting point
MAIN
	JSR INIT_THINKING_LOGS
	JSR PRINT_WELCOME
	JSR PLAYER_SELECT
    JSR PRINT_GAMEBOARD
	JSR GAME_LOOP ; Start game loop
HALT


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
; Repeat for COLUMN_INDEX
; Variables and labels as needed

VALIDATE_INPUT
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR PROCESS_ROW
    JSR PROCESS_COLUMN

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

REF4_PLAYER_ROW    .FILL PLAYER_ROW
REF4_PLAYER_COLUMN .FILL PLAYER_COLUMN
REF4_SELECTED_ROW    .FILL SELECTED_ROW
REF4_SELECTED_COLUMN .FILL SELECTED_COLUMN
REF4_ROW_A .FILL ROW_A
REF4_ROW_B .FILL ROW_B
REF4_ROW_C .FILL ROW_C
REF4_COL_1 .FILL COL_1
REF4_COL_2 .FILL COL_2
REF4_COL_3 .FILL COL_3
GET_PLAYER_INPUT
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    GETC                     ; Read a character (row)
    OUT                      ; Echo the character
    LD R1, REF4_PLAYER_ROW
    STR R0, R1, #0           ; Store the row character
    GETC                     ; Read a character (column)
    OUT                      ; Echo the character
    LD R1, REF4_PLAYER_COLUMN
    STR R0, R1, #0           ; Store the column character

    JSR PRINT_NEW_LINE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

; convert ASCII to number
PROCESS_ROW
    LD R4, REF4_PLAYER_ROW
    LDR R0, R4, #0          ; Load the selected row

    ; Compare Row Character
    LD R4, REF4_ROW_A
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_A

    LD R4, REF4_ROW_B
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_B

    LD R4, REF4_ROW_C
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_C

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    BR INPUT_ERROR

; convert ASCII to number
PROCESS_COLUMN
    LD R4, REF4_PLAYER_COLUMN
    LDR R0, R4, #0          ; Load the selected col

    ; Compare Row Character
    LD R4, REF4_COL_1
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_1

    LD R4, REF4_COL_2
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_2

    LD R4, REF4_COL_3
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_3
    
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    ADD R6, R6, #1   ; Increment stack pointer

    BR INPUT_ERROR

; Row/Col starts at 0 goes to 2
ROW_IS_A
    AND R2, R2, #0
    ADD R2, R2, #0
    LD R3, REF4_SELECTED_ROW
    STR R2, R3, #0
    RET
ROW_IS_B
    AND R2, R2, #0
    ADD R2, R2, #1
    LD R3, REF4_SELECTED_ROW
    STR R2, R3, #0
    RET
ROW_IS_C
    AND R2, R2, #0
    ADD R2, R2, #2
    LD R3, REF4_SELECTED_ROW
    STR R2, R3, #0
    RET
COL_IS_1
    AND R2, R2, #0
    ADD R2, R2, #0
    LD R3, REF4_SELECTED_COLUMN
    STR R2, R3, #0
    RET
COL_IS_2
    AND R2, R2, 0
    ADD R2, R2, #1
    LD R3, REF4_SELECTED_COLUMN
    STR R2, R3, #0
    RET
COL_IS_3
    AND R2, R2, #0
    ADD R2, R2, #2
    LD R3, REF4_SELECTED_COLUMN
    STR R2, R3, #0
    RET

REF_SINGLE_PLAYER .FILL SINGLE_PLAYER
REF_LOG_SELECT_PLAYERS .FILL LOG_SELECT_PLAYERS
REF_LOG_INVALID_PLAYER_SELECTION .FILL LOG_INVALID_PLAYER_SELECTION
REF1_LOG_EMPTY_LINE .FILL LOG_EMPTY_LINE
PLAYER_SELECT:
    LD R0, REF_LOG_SELECT_PLAYERS  ; Load the address of the prompt string into R0
    PUTS            ; Write the string to the console

    GETC            ; Read a character from the keyboard
    OUT             ; Echo the character
    ADD R0, R0, #-16 ; Convert ASCII to integer (assuming input is '1' or '2') (subtract 48)
    ADD R0, R0, #-16
    ADD R0, R0, #-16

    ; Check if input is valid (1 or 2)
    ADD R1, R0, #-1  ; Subtract 1 from input
    BRz SELECT_ONE_PLAYER ; If zero, input is 1
    ADD R1, R0, #-2  ; Subtract 2 from input
    BRz SELECT_TWO_PLAYER ; If zero, input is 2

    ; If input is not valid, loop back
    LD R0, REF_LOG_INVALID_PLAYER_SELECTION
    PUTS
    BRnzp PLAYER_SELECT
SELECT_ONE_PLAYER
    AND R0, R0, #0
    ADD R0, R0, #1
    LD R1, REF_SINGLE_PLAYER
    STR R0, R1, #0
    LD R0, REF1_LOG_EMPTY_LINE
    PUTS
    PUTS
    RET
SELECT_TWO_PLAYER
    AND R0, R0, #0
    ADD R0, R0, #0
    LD R1, REF_SINGLE_PLAYER
    STR R0, R1, #0
    LD R0, REF1_LOG_EMPTY_LINE
    PUTS
    PUTS
    RET


REF_LOG_EMPTY_LINE .FILL LOG_EMPTY_LINE
PRINT_NEW_LINE
    LD R0, REF_LOG_EMPTY_LINE   ; Load the address of the input prompt
    PUTS                     ; Display the prompt
    RET
; Helper constants
THREE .FILL #3
; Subroutine to multiply a number in R1 by 3
MULT_BY_THREE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Initialize R0 to 0 (to store the result) and R6 to 3 (as a counter)
    AND R0, R0, #0
    LD R5, THREE

MULT_LOOP
    ADD R0, R0, R1            ; Add R1 to R0
    ADD R5, R5, #-1           ; Decrement the counter
    BRp MULT_LOOP             ; Continue loop while counter is positive

    ; Return the result in R1
    ADD R1, R0, #0

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

; CHECK_MATCHING subroutine
; Assumptions: R0 = check_value, R1 = compare1, R2 = compare2, R3 = compare3
; Returns: R4 = 1 if all match, 0 otherwise
; Also leaves last stack operation as Positive or Zero for branch operations
CHECK_MATCHING
    ; Make R5 negative
    ADD R5, R0, #0
    NOT R5, R5
    ADD R5, R5, #1 ; Add 1 2's comp

    ; Compare check_value with compare1
    ADD R4, R1, R5
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; Compare check_value with compare2
    ADD R4, R2, R5
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; Compare check_value with compare3
    ADD R4, R3, R5
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; If all match
    AND R4, R4, #0  ; Clear R4
    ADD R4, R4, #1  ; Set R4 to 1 (all values match)
    RET             ; Return from subroutine

REF3_TILE_A1 .FILL TILE_A1
ALL_TILES_FILLED
    LD R5, REF3_TILE_A1
    AND R4, R4, #0
    ADD R4, R4, #9 ; 9 tiles in our grid
CHECK_LOOP
    LDR R0, R5, #0       ; Load the value of the current variable into R0
    BRz NOT_ALL_DEFINED         ; Branch to SET_FLAG if the value is zero
    ADD R5, R5, #1       ; Increment the address pointer
    ADD R4, R4, #-1      ; Decrement the counter
    BRp CHECK_LOOP       ; Repeat if there are more variables
    AND R0, R0, #0
    ADD R0, R0, #1 ; return pos
    RET
NOT_ALL_DEFINED
    AND R0, R0, #0
    ADD R0, R0, #0 ; return zero
    RET

NOT_MATCH
    AND R4, R4, #0  ; Set R4 to 0 (no match)
    ADD R4, R4, #0  ; Perform ADD so that we can branch later
    RET             ; Return from subroutine

REF_THINKING_STRINGS .FILL THINKING_STRINGS
REF_CURRENT_THINKING_STRING .FILL CURRENT_THINKING_STRING
REF_END_THINKING_STRINGS .FILL END_THINKING_STRINGS
REF_END_THINKING_STRING .FILL END_THINKING_STRING
INIT_THINKING_LOGS
    ; Initialize pointers
    LD R0, REF_THINKING_STRINGS       ; Load the address of the first string into R0
    LD R1, REF_CURRENT_THINKING_STRING
    STR R0, R1, #0
    LD R0, REF_END_THINKING_STRINGS   ; Load the address of the end marker into R0
    LD R1, REF_END_THINKING_STRING
    STR R0, R1, #0
    RET
; Cycle through strings and log
LOG_THINKING
    LD R0, REF_CURRENT_THINKING_STRING ; Load the address of the pointer to the current string
    LDR R0, R0, #0                     ; Load the current string address into R0
    PUTS                                ; 'Log' the current string
    ADD R1, R0, #1                      ; Move to the next character (after PUTS)
    CHECK_LOG_LOOP
        LDR R2, R1, #0                  ; Load the character at R1
        BRz ADVANCE                     ; If null terminator, advance to next string
        ADD R1, R1, #1                  ; Else, go to the next character
        BR CHECK_LOG_LOOP
    ADVANCE
        LD R2, REF_END_THINKING_STRING  ; Load the address of the pointer to END_STRINGS
        LDR R2, R2, #0                  ; Load the address of END_STRINGS
        ADD R1, R1, #1                  ; Move to the start of the next string
        NOT R3, R2                      ; Prepare to check for wrap-around
        ADD R3, R3, #1
        ADD R3, R1, R3                  ; If R1 == R2, we need to wrap around
        BRz WRAP_AROUND                 ; Check for wrap-around
        LD R0, REF_CURRENT_THINKING_STRING ; Update current string pointer
        STR R1, R0, #0
        RET
    WRAP_AROUND
        LD R1, REF_THINKING_STRINGS       ; Reset to the first string
        LD R0, REF_CURRENT_THINKING_STRING
        STR R1, R0, #0
        RET

REF2_PLAYER .FILL PLAYER
REF2_AI .FILL AI
REF2_PLAYER_ROW .FILL PLAYER_ROW
REF2_PLAYER_COLUMN .FILL PLAYER_COLUMN
REF2_CURRENT_PLAYER .FILL CURRENT_PLAYER
REF2_LOG_EMPTY_LINE .FILL LOG_EMPTY_LINE

REF2_ROW_A .FILL ROW_A
REF2_ROW_B .FILL ROW_B
REF2_ROW_C .FILL ROW_C
REF2_COL_1 .FILL COL_1
REF2_COL_2 .FILL COL_2
REF2_COL_3 .FILL COL_3

REF2_TILE_A1 .FILL TILE_A1
REF2_TILE_A2 .FILL TILE_A2
REF2_TILE_A3 .FILL TILE_A3
REF2_TILE_B1 .FILL TILE_B1
REF2_TILE_B2 .FILL TILE_B2
REF2_TILE_B3 .FILL TILE_B3
REF2_TILE_C1 .FILL TILE_C1
REF2_TILE_C2 .FILL TILE_C2
REF2_TILE_C3 .FILL TILE_C3

AI_PROCESS_MOVE
    BR AI_CHOOSE_TILE

AI_CHOOSE_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; We are checking if there is a win for the AI availabile
    LD R0, REF2_AI
    LDR R0, R0, #0
    LD R5, REF_PLAYER_TO_CHECK
    STR R0, R5, #0
    JSR AI_CHOOSE_TILE_CHECK_WIN
    BRp AI_CHOOSE_TILE_DONE
    ; We are checking if there is a win for the Player availabile
    ; so that we can block them :)
    LD R0, REF2_PLAYER
    LDR R0, R0, #0
    LD R5, REF_PLAYER_TO_CHECK
    STR R0, R5, #0
    LD R5, REF2_CURRENT_PLAYER
    STR R0, R5, #0
    JSR AI_CHOOSE_TILE_CHECK_WIN
    BRp AI_CHOOSE_TILE_DONE

    ; If there isn't a win state, or a block, 
    ; then maybe just place it in the best random place
    ; This algorithm needs to be improved to select good locations for the AI to go
    JSR AI_CHOOSE_TILE_BEST_RANDOM
AI_CHOOSE_TILE_DONE
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

AI_CHOOSE_TILE_CHECK_WIN
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack
CHECK_A1
    ; R1 is the tile to check
    LD R1, REF2_TILE_A1
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_A2
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_A2
    ; R1 is the tile to check
    LD R1, REF2_TILE_A2
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_A3
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_A3
    ; R1 is the tile to check
    LD R1, REF2_TILE_A3
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_B1
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_B1
    ; R1 is the tile to check
    LD R1, REF2_TILE_B1
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_B2
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_B2
    ; R1 is the tile to check
    LD R1, REF2_TILE_B2
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_B3
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_B3
    ; R1 is the tile to check
    LD R1, REF2_TILE_B3
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_C1
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_C1
    ; R1 is the tile to check
    LD R1, REF2_TILE_C1
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_C2
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_C2
    ; R1 is the tile to check
    LD R1, REF2_TILE_C2
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_C3
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_C3
    ; R1 is the tile to check
    LD R1, REF2_TILE_C3
    JSR AI_CHECK_IF_TILE_WINS
    BRz CHECK_NO_WIN
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
CHECK_NO_WIN
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R0, R0, #0
    ADD R0, R0, #0   ; Push a zero op to the stack
    RET

AI_CHOOSE_TILE_BEST_RANDOM
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; check middle
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING

    ; check corner 1
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check corner 2
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check corner 3
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check corner 4
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING

    ; check mid 1
    JSR AI_SELECT_ROW_A
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check mid 2
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_1
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check mid 3
    JSR AI_SELECT_ROW_B
    JSR AI_SELECT_COL_3
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING
    ; check mid 4
    JSR AI_SELECT_ROW_C
    JSR AI_SELECT_COL_2
    JSR AI_ATTEMPT_TO_CLAIM_TILE
    BRp AI_DONE_PROCESSING

    ; We should'nt ever get here, but it's included because I like it here :)
    BR CHECK_NO_WIN

AI_DONE_PROCESSING
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    LD R0, REF2_PLAYER_ROW
    PUTS
    ; We don't seem to need to log the column as well
    ; an odd bug that might need fixing at some point
    ; but it works right now.
    ; LD R0, REF2_PLAYER_COLUMN
    ; PUTS
    LD R0, REF2_LOG_EMPTY_LINE
    PUTS

    AND R0, R0, #0
    ADD R0, R0, #1   ; Push a pos op to the stack
    RET

AI_ATTEMPT_TO_CLAIM_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R0, REF2_AI
    LDR R0, R0, #0
    LD R1, REF2_CURRENT_PLAYER
    STR R0, R1, #0

    JSR VALIDATE_INPUT
    JSR SELECT_TILE
    JSR CHECK_TILE
    BRp AI_CLAIM_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R5, R5, #0
    ADD R5, R5, #0 ; Leave a zero op on the stack
    RET

AI_CLAIM_TILE
    ; don't pop onto the stack because of the way
    ; we use this subroutine!
    JSR CLAIM_TILE
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R5, R5, #0
    ADD R5, R5, #1 ; Leave a positive op on the stack (included to be explicit)
    RET

REF_PREVIOUS_VALUE .FILL PREVIOUS_VALUE
REF_PLAYER_TO_CHECK .FILL PLAYER_TO_CHECK
; R0 is the player to check for
; R1 is the tile to check
; Tile value gets updated then restored at the end of this
AI_CHECK_IF_TILE_WINS
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Save our registers
    LD R5, REF_PREVIOUS_VALUE
    LDR R4, R1, #0 ; Value at Mem location of R1
    STR R4, R5, #0

    ; ADD R5, R0, #0

    ; Check if tile is already taken
    LD R5, REF_SELECTED_TILE_ADDR
    STR R1, R5, #0
    JSR CHECK_TILE
    ; If it is, just branch below and continue
    BRZ TILE_DOES_NOT_WIN

    ; Set the TILE to the player we are checking for
    LD R0, REF_SELECTED_TILE_ADDR
    LDR R0, R0, #0
    LD R5, REF_PLAYER_TO_CHECK
    LDR R5, R5, #0
    STR R5, R0, #0

    ; Check if there was a win
    JSR CHECK_WIN
    BRP TILE_WINS
    BR TILE_DOES_NOT_WIN

TILE_DOES_NOT_WIN
    ; Restore the old value
    LD R0, REF_SELECTED_TILE_ADDR
    LDR R0, R0, #0
    LD R1, REF_PREVIOUS_VALUE
    LDR R1, R1, #0
    STR R1, R0, #0

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R5, R5, #0
    ADD R5, R5, #0 ; Leave a zero op on the stack
    RET

TILE_WINS
    ; Restore the old value
    LD R0, REF_SELECTED_TILE_ADDR
    LDR R0, R0, #0
    LD R1, REF_PREVIOUS_VALUE
    LDR R1, R1, #0
    STR R1, R0, #0

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R5, R5, #0
    ADD R5, R5, #1 ; Leave a pos op on the stack
    RET

AI_SELECT_ROW_A
    LD R1, REF2_ROW_A
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_ROW
    STR R1, R2, #0
    RET
AI_SELECT_ROW_B
    LD R1, REF2_ROW_B
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_ROW
    STR R1, R2, #0
    RET
AI_SELECT_ROW_C
    LD R1, REF2_ROW_C
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_ROW
    STR R1, R2, #0
    RET
AI_SELECT_COL_1
    LD R1, REF2_COL_1
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_COLUMN
    STR R1, R2, #0
    RET
AI_SELECT_COL_2
    LD R1, REF2_COL_2
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_COLUMN
    STR R1, R2, #0
    RET
AI_SELECT_COL_3
    LD R1, REF2_COL_3
    LDR R1, R1, #0
    LD R2, REF2_PLAYER_COLUMN
    STR R1, R2, #0
    RET


REF_SELECTED_ROW .FILL SELECTED_ROW
REF_SELECTED_COLUMN .FILL SELECTED_COLUMN
REF_SELECTED_TILE_ADDR .FILL SELECTED_TILE_ADDR

SELECT_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R4, REF_SELECTED_ROW      ; Load the address of the selected row
    LDR R1, R4, #0            ; Load the selected row number into R1
    LD R4, REF_SELECTED_COLUMN   ; Load the address of the selected column
    LDR R2, R4, #0            ; Load the selected column number into R2

    ; Call the multiplication subroutine to multiply row index by 3
    JSR MULT_BY_THREE         ; R1 will contain row index * 3 after this call

    ; Calculate the address offset based on row and column
    ADD R1, R1, R2            ; Add the column index to the row index
    LD R3, REF_TILE_A1       ; Load the starting address of tiles into R3
    ADD R3, R3, R1            ; Add this offset to the base address

    ; R3 now contains the memory address of the selected tile
    LD R4, REF_SELECTED_TILE_ADDR
    STR R3, R4, #0 ; Store it in SELECTED_TILE_ADDR for later use

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

; Check if the tile is taken and act appropriately
; This method is for the player, the AI also uses CHECK_TILE
; This method adds invalid input logging and will loop back to requesting input
CHECK_TILE_PLAYER
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR CHECK_TILE   ; Check if tile is taken
    BRZ PLAYER_TILE_NOT_AVAILABLE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

REF_INPUT_ERROR_TILE_NOT_AVAILABLE .FILL INPUT_ERROR_TILE_NOT_AVAILABLE

PLAYER_TILE_NOT_AVAILABLE
    LD R0, REF_INPUT_ERROR_TILE_NOT_AVAILABLE
    JMP R0

; Subroutine to check if the selected tile is available
; This is used extensively throughout the code!
; Please do not break it <3 -Sky
CHECK_TILE
    LD R0, REF_SELECTED_TILE_ADDR ; Load the address of the selected tile
    LDR R0, R0, #0            ; Yes, we do have to do this twice.
    LDR R0, R0, #0            ; Load the value at the selected tile address

    LD R1, REF_EMPTY          ; Load the value representing an empty tile
    LDR R1, R1, #0
    NOT R0, R0                ; Invert the value at the tile
    ADD R0, R0, #1            ; Add 1 to the inverted value (2's complement)
    ADD R0, R0, R1            ; Add inverted value and EMPTY
    BRZ TILE_AVAILABLE        ; Branch if tile is empty

    AND R0, R0, #0
    ADD R0, R0, #0 ; Leave a zero op on the stack
    RET

TILE_AVAILABLE
    AND R0, R0, #0
    ADD R0, R0, #1 ; Leave a positive op on the stack
    RET

SET_TILE
    LD R1, REF_SELECTED_TILE_ADDR ; Load the address of the selected tile
    LDR R1, R1, #0
    STR R0, R1, #0            ; Store the value in R0 (PLAYER, AI, or EMPTY) at the selected tile address
    RET

REF_EMPTY .FILL EMPTY
REF_PLAYER .FILL PLAYER
REF_PLAYER_2 .FILL PLAYER_2
REF_AI .FILL AI
; Print Tile Icon Subroutine
; R0 is used to pass the address of the tile
PRINT_TILE_ICON
    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_PLAYER     ; Load the value representing Player 1
    LDR R3, R3, #0        ; Have to perform a second load since it's a REF_
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted player value (2's complement)
    ADD R2, R2, R3        ; Compare tile with player
    BRZ PRINT_PLAYER_ICON ; Branch if tile is owned by player

    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_PLAYER_2     ; Load the value representing Player 2
    LDR R3, R3, #0
    NOT R3, R3              ; Invert for comparison
    ADD R3, R3, #1          ; Add 1 to the inverted AI's value for 2's complement
    ADD R2, R2, R3          ; Compare tile with AI
    BRZ PRINT_PLAYER_2_ICON ; Branch if tile is owned by AI

    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_AI         ; Load the value representing the AI
    LDR R3, R3, #0
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted AI's value for 2's complement
    ADD R2, R2, R3        ; Compare tile with AI
    BRZ PRINT_AI_ICON     ; Branch if tile is owned by AI

    LD R0, REF_EMPTY_ICON    ; Load the address of empty icon
    PUTS
    RET

REF_EMPTY_ICON .FILL EMPTY_ICON
REF_PLAYER_ICON .FILL PLAYER_ICON
REF_PLAYER_2_ICON .FILL PLAYER_2_ICON
REF_AI_ICON .FILL AI_ICON

PRINT_PLAYER_ICON
    LD R0, REF_PLAYER_ICON   ; Load the address of player 1 icon
    PUTS
    RET

PRINT_PLAYER_2_ICON
    LD R0, REF_PLAYER_2_ICON   ; Load the address of player 2 icon
    PUTS
    RET

PRINT_AI_ICON
    LD R0, REF_AI_ICON       ; Load the address of AI icon
    PUTS
    RET

; Gameboard Layout Constants
;     1   2   3
;
; A   X │ X │ O 
;    ───┼───┼───
; B     │ O │   
;    ───┼───┼───
; C   X │   │   

REF_COL_LABELS .FILL COL_LABELS
REF_ROW_DIVIDER .FILL ROW_DIVIDER
REF_MID_ROW .FILL MID_ROW
REF_END_ROW .FILL END_ROW
REF_START_ROW_A .FILL START_ROW_A
REF_START_ROW_B .FILL START_ROW_B
REF_START_ROW_C .FILL START_ROW_C

REF_TILE_A1 .FILL TILE_A1
REF_TILE_A2 .FILL TILE_A2
REF_TILE_A3 .FILL TILE_A3
REF_TILE_B1 .FILL TILE_B1
REF_TILE_B2 .FILL TILE_B2
REF_TILE_B3 .FILL TILE_B3
REF_TILE_C1 .FILL TILE_C1
REF_TILE_C2 .FILL TILE_C2
REF_TILE_C3 .FILL TILE_C3

PRINT_GAMEBOARD
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Print out all of the gameboard text
    LD R0, REF_COL_LABELS
    PUTS

    JSR PRINT_NEW_LINE

    ; Print Row A
    LD R0, REF_START_ROW_A
    PUTS

    LD R1, REF_TILE_A1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_A2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_A3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row B
    LD R0, REF_START_ROW_B
    PUTS

    LD R1, REF_TILE_B1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_B2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_B3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS


    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row C
    LD R0, REF_START_ROW_C
    PUTS

    LD R1, REF_TILE_C1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_C2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_C3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    JSR PRINT_NEW_LINE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

; Gameboard Layout Constants
;     1   2   3
;
; A   X │ X │ O 
;    ───┼───┼───
; B     │ O │   
;    ───┼───┼───
; C   X │   │   
;
COL_LABELS     .STRINGZ "     1   2   3  \n"
ROW_DIVIDER    .STRINGZ "    ───┼───┼─── \n"
MID_ROW        .STRINGZ " │ "
END_ROW        .STRINGZ "  \n"
START_ROW_A    .STRINGZ " A   "
START_ROW_B    .STRINGZ " B   "
START_ROW_C    .STRINGZ " C   "

LOG_SELECT_PLAYERS           .STRINGZ "Enter 1 for one-player mode, 2 for two-player mode: "
LOG_INVALID_PLAYER_SELECTION .STRINGZ "\nInvalid input. Please enter 1 or 2.\n"

LOG_PLAYER_1  .STRINGZ "Player 1: "
LOG_PLAYER_2  .STRINGZ "Player 2: "
LOG_PLAYER_AI  .STRINGZ "AI Player: "

LOG_WIN  .STRINGZ "\n You Won! You have bested me, care to push your luck...? \n\n\n"
LOG_LOSS .STRINGZ "\n You LOST, better luck next time!  \n\n\n"
LOG_TIE  .STRINGZ "\n You both tied, maybe give it another try \n\n\n"

LOG_EMPTY_LINE  .STRINGZ "\n"
LOG_BOT_THINK_1 .STRINGZ "bzzzz... *Beep* *boop* *zzz* *beep* *zap*"
LOG_BOT_THINK_2 .STRINGZ "*whrrr* *buzzzz* *burp*"
LOG_BOT_THINK_3 .STRINGZ "* you can hear someone quietly typing behind a curtain to your right *"

LOG_BOT_1 .STRINGZ "STARTUP COMPLETE!\n"
LOG_BOT_2 .STRINGZ "\n\n\n\n\n\n\nHello,\n"
LOG_BOT_3 .STRINGZ "HELLO AGAIN,\n"
LOG_BOT_4 .STRINGZ "Would you like to play a game of Tic-Tac-Toe?\n\n"
LOG_BOT_5 .STRINGZ "I SEE YOU HAVE NOT BEEN BEATEN ENOUGH TIMES\n"
LOG_BOT_6 .STRINGZ "HAVE YOU COME BACK FOR MORE PAIN AND MISORY?\n"
LOG_BOT_7 .STRINGZ "HAHA YOU FOOL! PREPARE TO BEATEN AGAIN BY THE GREAT SKYBOT!\n"

LOG_INPUT_1 .STRINGZ "What space would you like to claim?\n"
LOG_INPUT_2 .STRINGZ "Have you come back for more pain and misory? (y/n)\n"

LOG_ERROR_1 .STRINGZ "\nThat is not a valid input, please select a Row and Column using the Letter and Numbers for each column.\nHere are some example inputs:\nA3\nC1\nB2\n\n"
LOG_ERROR_2 .STRINGZ "\nThat space has already been claimed, please select a different one.\n\n"

LOG_BOT_X .STRINGZ "HAHA?\n"

LOG_INPUT_MOVE   .STRINGZ "Please"
LOG_START_GAME_2 .STRINGZ "HELLO PLAYER,"
LOG_START_GAME_3 .STRINGZ "HELLO PLAYER,"

; Data Section
CURRENT_THINKING_STRING .BLKW 1   ; Current string pointer
END_THINKING_STRING     .BLKW 1   ; End of strings marker
THINKING_STRINGS   .STRINGZ "* you can hear someone quietly typing behind a curtain to your right *\n"
                   .STRINGZ "*beep-boop* *scratch-head* *ponder*\n"
                   .STRINGZ "*peek-behind-curtain* *whisper-to-invisible-advisor* *nod-earnestly*\n"
                   .STRINGZ "*shuffle-cards* *peeks-at-hand* shuffles-again*\n"
                   .STRINGZ "*sneak-behind-curtain* *muffled-conversation* *reappear-with-confidence*\n"
                   .STRINGZ "*tap-dance* *spin* *freeze-in-pose*\n"
                   .STRINGZ "*pull-levers-frantically* *look-around-suspiciously* *big-red-button-push*\n"
                   .STRINGZ "*juggle-Xs-and-Os* *oops-drop quick-recover*\n"
                   .STRINGZ "*wizard-hat-on* *wave-magic-wand* *puff-of-smoke*\n"
                   .STRINGZ "*look-left* *look-right* *sneaky-grin*\n"
                   .STRINGZ "*curtain-shuffle* *peek-out-with-one-eye* *quickly-hide-back*\n"
                   .STRINGZ "*mime-pulling-rope* *lean-back* *pull-harder*\n"
                   .STRINGZ "*shadow-puppet-show-behind-curtain* *clap-hands* *take-a-bow*\n"
                   .STRINGZ "*magic-wand-wave* *poof* *confused-glance*\n"
                   .STRINGZ "*conduct-orchestra* *crescendo* *bow*\n"
                   .STRINGZ "*mime-wall-push* *exaggerated-struggle* *wipes-brow*\n"
                   .STRINGZ "*adjust-microphone-behind-curtain* *clear-throat* *silent-announcement*\n"
                   .STRINGZ "*invisible-typewriter* *nod-satisfied* *ding*\n"
                   .STRINGZ "*sift-through-treasure-map* *look-around-confused* *aha-moment*\n"
                   .STRINGZ "*pretend-to-paint* *step-back-admire* *thumb-up*\n"
                   .STRINGZ "*gaze-into-crystal-ball* *mystified-look* *snap-fingers*\n"
                   .STRINGZ "*tug-curtain-cord* *reveal-contraption* *scratch-head-in-confusion*\n"
                   .STRINGZ "*puppeteer-movement* *tangle-in-strings* *untangle-with-a-flourish*\n"
                   .STRINGZ "*simulate-rocket-launch* *countdown* *blast-off*\n"
                   .STRINGZ "*wear-detective-hat* *inspect-with-magnifying-glass* *nod-approvingly*\n"
                   .STRINGZ "*behind-curtain-dance* *curtain-sways-to-music* *curtain-falls-silence*\n"
                   .STRINGZ "*mime-eating-popcorn* *look-at-board-intensely* *popcorn-spill*\n"
                   .STRINGZ "*build-sandcastle* *place-flag-on-top* *admiring-glance*\n"
                   .STRINGZ "*play-invisible-pinball* *hit-flippers* *tilt-alarm*\n"
                   .STRINGZ "*pull-back-curtain-slowly* *reveal-tic-tac-toe-board* *curtain-closes-quickly*\n"
                   .STRINGZ "*pretend-to-surf* *balance-on-board* *wipeout-into-water*\n"
END_THINKING_STRINGS

.END
