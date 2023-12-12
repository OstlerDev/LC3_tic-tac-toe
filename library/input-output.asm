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