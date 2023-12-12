

REF_SELECTED_ROW .FILL SELECTED_ROW
REF_SELECTED_COLUMN .FILL SELECTED_COLUMN
REF_SELECTED_TILE_ADDR .FILL SELECTED_TILE_ADDR

SELECT_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LD R4, REF_SELECTED_ROW      ; Load the address of the selected row
    LDR R1, R4, #0            ; Load the selected row number into R1
    LD R4, REF_SELECTED_COLUMN   ; Load the address of the selected column
    LDR R2, R4, #0            ; Load the selected column number into R2

    ; Call the multiplication subroutine to multiply row index by 3
    JSR MULT_BY_THREE         ; R1 will contain row index * 3 after this call

    ; Calculate the address offset based on row and column
    ADD R1, R1, R2            ; Add the column index to the row index
    LD R3, REF_TILE_A1       ; Load the starting address of tiles into R3
    ADD R3, R3, R1            ; Add this offset to the base address

    ; R3 now contains the memory address of the selected tile
    LD R4, REF_SELECTED_TILE_ADDR
    STR R3, R4, #0 ; Store it in SELECTED_TILE_ADDR for later use

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET


REF_INPUT_ERROR_TILE_NOT_AVAILABLE .FILL INPUT_ERROR_TILE_NOT_AVAILABLE

; Check if the tile is taken and act appropriately
; This method is for the player, the AI also uses CHECK_TILE
; This method adds invalid input logging and will loop back to requesting input
CHECK_TILE_PLAYER
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR CHECK_TILE   ; Check if tile is taken
    BRP PLAYER_TILE_NOT_AVAILABLE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

PLAYER_TILE_NOT_AVAILABLE
    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    BRP REF_INPUT_ERROR_TILE_NOT_AVAILABLE

; Subroutine to check if the selected tile is available
; This is used extensively throughout the code!
; Please do not break it <3 -Sky
CHECK_TILE
    LD R0, REF_SELECTED_TILE_ADDR ; Load the address of the selected tile
    LDR R0, R0, #0            ; Yes, we do have to do this twice.
    LDR R0, R0, #0            ; Load the value at the selected tile address

    LD R1, REF_EMPTY          ; Load the value representing an empty tile
    LDR R1, R1, #0
    NOT R0, R0                ; Invert the value at the tile
    ADD R0, R0, #1            ; Add 1 to the inverted value (2's complement)
    ADD R0, R0, R1            ; Add inverted value and EMPTY
    BRZ TILE_AVAILABLE        ; Branch if tile is empty

    AND R0, R0, #0
    ADD R0, R0, #0 ; Leave a zero op on the stack
    RET

TILE_AVAILABLE
    ; AND R3, R3, #0
    ; ADD R3, R3, #1
    ; Do I need this...?
    ; LD R4, REF_SELECTED_COLUMN
    ; STR R2, R4, #0 
    AND R0, R0, #0
    ADD R0, R0, #1 ; Leave a positive op on the stack
    RET

SET_TILE
    LD R1, REF_SELECTED_TILE_ADDR ; Load the address of the selected tile
    LDR R1, R1, #0
    STR R0, R1, #0            ; Store the value in R0 (PLAYER, AI, or EMPTY) at the selected tile address
    RET

REF_EMPTY .FILL EMPTY
REF_PLAYER .FILL PLAYER
REF_PLAYER_2 .FILL PLAYER_2
REF_AI .FILL AI
; Print Tile Icon Subroutine
; R0 is used to pass the address of the tile
PRINT_TILE_ICON
    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_PLAYER     ; Load the value representing Player 1
    LDR R3, R3, #0        ; Have to perform a second load since it's a REF_
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted player value (2's complement)
    ADD R2, R2, R3        ; Compare tile with player
    BRZ PRINT_PLAYER_ICON ; Branch if tile is owned by player

    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_PLAYER_2     ; Load the value representing Player 2
    LDR R3, R3, #0
    NOT R3, R3              ; Invert for comparison
    ADD R3, R3, #1          ; Add 1 to the inverted AI's value for 2's complement
    ADD R2, R2, R3          ; Compare tile with AI
    BRZ PRINT_PLAYER_2_ICON ; Branch if tile is owned by AI

    LDR R2, R1, #0 ; Load the value of the tile

    LD R3, REF_AI         ; Load the value representing the AI
    LDR R3, R3, #0
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted AI's value for 2's complement
    ADD R2, R2, R3        ; Compare tile with AI
    BRZ PRINT_AI_ICON     ; Branch if tile is owned by AI

    LD R0, REF_EMPTY_ICON    ; Load the address of empty icon
    PUTS
    RET

REF_EMPTY_ICON .FILL EMPTY_ICON
REF_PLAYER_ICON .FILL PLAYER_ICON
REF_PLAYER_2_ICON .FILL PLAYER_2_ICON
REF_AI_ICON .FILL AI_ICON

PRINT_PLAYER_ICON
    LD R0, REF_PLAYER_ICON   ; Load the address of player 1 icon
    PUTS
    RET

PRINT_PLAYER_2_ICON
    LD R0, REF_PLAYER_2_ICON   ; Load the address of player 2 icon
    PUTS
    RET

PRINT_AI_ICON
    LD R0, REF_AI_ICON       ; Load the address of AI icon
    PUTS
    RET

; Gameboard Layout
;     1     2     3
;        #     #     
; A   X  #     #  O  
;        #     #    
;   #################
;        #     #     
; B      #  O  #     
;        #     #     
;   #################
;        #     #     
; C   X  #     #     
;        #     #    

REF_COL_LABELS .FILL COL_LABELS
REF_ROW_DIVIDER .FILL ROW_DIVIDER
REF_MID_ROW .FILL MID_ROW
REF_END_ROW .FILL END_ROW
REF_START_ROW_A .FILL START_ROW_A
REF_START_ROW_B .FILL START_ROW_B
REF_START_ROW_C .FILL START_ROW_C

REF_TILE_A1 .FILL TILE_A1
REF_TILE_A2 .FILL TILE_A2
REF_TILE_A3 .FILL TILE_A3
REF_TILE_B1 .FILL TILE_B1
REF_TILE_B2 .FILL TILE_B2
REF_TILE_B3 .FILL TILE_B3
REF_TILE_C1 .FILL TILE_C1
REF_TILE_C2 .FILL TILE_C2
REF_TILE_C3 .FILL TILE_C3

PRINT_GAMEBOARD
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    ; Print out all of the gameboard text
    LD R0, REF_COL_LABELS
    PUTS

    JSR PRINT_NEW_LINE

    ; Print Row A
    LD R0, REF_START_ROW_A
    PUTS

    LD R1, REF_TILE_A1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_A2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_A3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row B
    LD R0, REF_START_ROW_B
    PUTS

    LD R1, REF_TILE_B1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_B2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_B3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS


    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row C
    LD R0, REF_START_ROW_C
    PUTS

    LD R1, REF_TILE_C1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_C2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R1, REF_TILE_C3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    JSR PRINT_NEW_LINE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET
