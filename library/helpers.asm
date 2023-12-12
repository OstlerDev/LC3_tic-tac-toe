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

REF_LOG_EMPTY_LINE .FILL LOG_EMPTY_LINE
PRINT_NEW_LINE
    LD R0, REF_LOG_EMPTY_LINE   ; Load the address of the input prompt
    PUTS                     ; Display the prompt
    RET