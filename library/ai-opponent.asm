
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
    ; LD R5, REF_PLAYER_TO_CHECK
    ; STR R0, R5, #0
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

 ; We can create a "pseudo" random variable to give the AI some variablility


 ; AI pseudo-code

 ; function ticTacToeAI(board):
 ;    for each cell in board:
 ;        if cell is empty:
 ;            # Check if AI can win
 ;            if placing AI's symbol here makes AI win:
 ;                return cell's position

 ;    for each cell in board:
 ;        if cell is empty:
 ;            # Check if opponent can win
 ;            if placing opponent's symbol here makes them win:
 ;                return cell's position

 ;    if center is empty:
 ;        return center's position

 ;    for each corner in corners:
 ;        if corner is empty:
 ;            return corner's position

 ;    for each cell in board:
 ;        if cell is empty:
 ;            return cell's position
