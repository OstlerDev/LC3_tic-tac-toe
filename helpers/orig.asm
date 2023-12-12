.ORIG x3000
LD R6, STACK_PTR
JSR MAIN  ; Jump to main subroutine immediately, by passing needing to step through each instruction
STACK_PTR .FILL xFDFF
