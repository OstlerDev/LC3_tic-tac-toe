
REF2_AI .FILL AI
REF2_PLAYER_ROW .FILL PLAYER_ROW
REF2_PLAYER_COLUMN .FILL PLAYER_COLUMN

REF2_ROW_A .FILL ROW_A
REF2_ROW_B .FILL ROW_B
REF2_ROW_C .FILL ROW_C
REF2_COL_1 .FILL COL_1
REF2_COL_2 .FILL COL_2
REF2_COL_3 .FILL COL_3

AI_PROCESS_MOVE
    BR AI_CHOOSE_TILE

AI_CHOOSE_TILE
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
    BR AI_DONE_PROCESSING

AI_DONE_PROCESSING
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

AI_ATTEMPT_TO_CLAIM_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR VALIDATE_INPUT
    JSR SELECT_TILE
    JSR CHECK_TILE
    BRp AI_CLAIM_TILE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R0, R0, #0
    ADD R0, R0, #0 ; Leave a zero op on the stack
    RET

AI_CLAIM_TILE
    ; don't pop onto the stack because of the way
    ; we use this subroutine!
    JSR CLAIM_TILE
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    AND R0, R0, #0
    ADD R0, R0, #1 ; Leave a positive op on the stack (included to be explicit)
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
