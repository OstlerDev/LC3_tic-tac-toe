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

