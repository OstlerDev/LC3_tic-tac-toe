; Push R7 onto the stack
ADD R6, R6, #-1  ; Decrement stack pointer
STR R7, R6, #0   ; Store R7 on the stack

; Subroutine code...

; Pop R7 off the stack
LDR R7, R6, #0   ; Load R7 from the stack
ADD R6, R6, #1   ; Increment stack pointer