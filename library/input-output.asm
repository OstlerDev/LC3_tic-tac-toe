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

GET_PLAYER_INPUT
    GETC                     ; Read a character (row)
    OUT                      ; Echo the character
    ST R0, PLAYER_ROW        ; Store the row character
    GETC                     ; Read a character (column)
    OUT                      ; Echo the character
    ST R0, PLAYER_COLUMN     ; Store the column character
    RET                      ; Return from subroutine

; convert ASCII to number
PROCESS_ROW
    LEA R4, PLAYER_ROW
    LDR R0, R4, #0          ; Load the selected row

    ; Compare Row Character
    LEA R4, ROW_A
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_A
    LEA R4, ROW_B
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_B
    LEA R4, ROW_C
    LDR R1, R4, #0          ; Load the selected row
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ ROW_IS_C

    LEA R4, SELECTED_ROW     ; Check if we matched a row, if not, branch to input error
    LDR R2, R4, #0
    ADD R2, R2, #0
    BRZ INPUT_ERROR

    RET

; convert ASCII to number
PROCESS_COLUMN
    LEA R4, PLAYER_COLUMN
    LDR R0, R4, #0          ; Load the selected col

    ; Compare Row Character
    LEA R4, COL_1
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_1
    LEA R4, COL_2
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_2
    LEA R4, COL_3
    LDR R1, R4, #0          ; Load the selected col
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    BRZ COL_IS_3
    
    LEA R4, SELECTED_COLUMN  ; Check if we matched a col, if not, branch to input error
    LDR R2, R4, #0
    ADD R2, R2, #0
    BRZ INPUT_ERROR

    RET

ROW_IS_A
    AND R2, R2, #1
    ST R2, SELECTED_ROW
    RET
ROW_IS_B
    AND R2, R2, #2
    ST R2, SELECTED_ROW
    RET
ROW_IS_C
    AND R2, R2, #3
    ST R2, SELECTED_ROW
    RET
COL_IS_1
    AND R2, R2, #1
    ST R2, SELECTED_COLUMN
    RET
COL_IS_2
    AND R2, R2, #2
    ST R2, SELECTED_COLUMN
    RET
COL_IS_3
    AND R2, R2, #3
    ST R2, SELECTED_COLUMN
    RET
