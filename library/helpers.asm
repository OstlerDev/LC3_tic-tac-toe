
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
