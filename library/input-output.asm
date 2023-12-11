

GET_PLAYER_INPUT
    GETC                     ; Read a character (row)
    OUT                      ; Echo the character
    ST R0, PLAYER_ROW        ; Store the row character
    GETC                     ; Read a character (column)
    OUT                      ; Echo the character
    ST R0, PLAYER_COLUMN     ; Store the column character
    RET                      ; Return from subroutine

; Compare R0 to R1
CHECK_MATCH
    NOT R4, R1
    ADD R4, R4, #1            ; Add 1 to the inverted value (2's complement)
    ADD R4, R4, R0
    RET

; Subroutine to convert ASCII characters to indices based on explicit matching
PROCESS_ROW
    LEA R4, PLAYER_ROW
    LDR R0, R4, #0          ; Load the selected row

    ; Compare Row Character
    LEA R4, ROW_A
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ ROW_IS_A
    LEA R4, ROW_B
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ ROW_IS_B
    LEA R4, ROW_C
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ ROW_IS_C

    BR INPUT_ERROR

; Subroutine to convert ASCII characters to indices based on explicit matching
PROCESS_COLUMN
    LEA R4, PLAYER_COLUMN
    LDR R0, R4, #0          ; Load the selected row

    ; Compare Row Character
    LEA R4, COL_1
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ COL_IS_1
    LEA R4, COL_2
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ COL_IS_2
    LEA R4, COL_3
    LDR R1, R4, #0          ; Load the selected row
    JSR CHECK_MATCH
    BRZ COL_IS_3
    
    BR INPUT_ERROR

ROW_IS_A
	AND R0, R0, #1
    ST R0, SELECTED_ROW
    BR PROCESS_COLUMN
ROW_IS_B
	AND R0, R0, #2
    ST R0, SELECTED_ROW
    BR PROCESS_COLUMN
ROW_IS_C
	AND R0, R0, #3
    ST R0, SELECTED_ROW
    BR PROCESS_COLUMN
COL_IS_1
	AND R0, R0, #1
    ST R0, SELECTED_COLUMN
    BR CONTINUE_PLAYER_MOVE
COL_IS_2
	AND R0, R0, #2
    ST R0, SELECTED_COLUMN
    BR CONTINUE_PLAYER_MOVE
COL_IS_3
	AND R0, R0, #3
    ST R0, SELECTED_COLUMN
    BR CONTINUE_PLAYER_MOVE

; Repeat for COLUMN_INDEX
; Variables and labels as needed

VALIDATE_INPUT
    JSR PROCESS_ROW
    JSR PROCESS_COLUMN
    RET