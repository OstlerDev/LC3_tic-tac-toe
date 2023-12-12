
REF_LOG_EMPTY_LINE .FILL LOG_EMPTY_LINE
PRINT_NEW_LINE
    LD R0, REF_LOG_EMPTY_LINE   ; Load the address of the input prompt
    PUTS                     ; Display the prompt
    RET

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
    ; Make R0 negative
    NOT R0, R0
    ADD R0, R0, #1 ; Add 1 2's comp

    ; Compare check_value with compare1
    ADD R4, R1, R0
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; Compare check_value with compare2
    ADD R4, R2, R0
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; Compare check_value with compare3
    ADD R4, R3, R0
    BRnp NOT_MATCH  ; If not zero, values don't match, go to NOT_MATCH

    ; If all match
    AND R4, R4, #0  ; Clear R4
    ADD R4, R4, #1  ; Set R4 to 1 (all values match)
    RET             ; Return from subroutine

NOT_MATCH
    AND R4, R4, #0  ; Set R4 to 0 (no match)
    ADD R4, R4, #0  ; Perform ADD so that we can branch later
    RET             ; Return from subroutine