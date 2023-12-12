

SELECT_TILE
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    LEA R4, SELECTED_ROW      ; Load the address of the selected row
    LDR R1, R4, #0            ; Load the selected row number into R1
    LEA R4, SELECTED_COLUMN   ; Load the address of the selected column
    LDR R2, R4, #0            ; Load the selected column number into R2

    ; Call the multiplication subroutine to multiply row index by 3
    JSR MULT_BY_THREE         ; R1 will contain row index * 3 after this call

    ; Calculate the address offset based on row and column
    ADD R1, R1, R2            ; Add the column index to the row index
    LEA R3, TILE_A1           ; Load the starting address of tiles into R3
    ADD R3, R3, R1            ; Add this offset to the base address

    ; R3 now contains the memory address of the selected tile
    ST R3, SELECTED_TILE_ADDR ; Store it in SELECTED_TILE_ADDR for later use

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer
    RET

; Check if the tile is taken and act appropriately
; This method is for the player, the AI also uses CHECK_TILE
CHECK_TILE_PLAYER
    ; Push R7 onto the stack
    ADD R6, R6, #-1  ; Decrement stack pointer
    STR R7, R6, #0   ; Store R7 on the stack

    JSR CHECK_TILE   ; Check if tile is taken, will store in TILE_STATUS

    ; Check if tile is taken
    ; 0 = taken
    ; 1 = available
    LD R3, TILE_STATUS
    ADD R3, R3, #-1
    BRN INPUT_ERROR_TILE_NOT_AVAILABLE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET

; Subroutine to check if the selected tile is available
; This is used extensively throughout the code!
; Please do not break it <3 -Sky
; TILE_STATUS
; 0 = taken
; 1 = available
CHECK_TILE
    LD R0, SELECTED_TILE_ADDR ; Load the address of the selected tile
    LDR R1, R0, #0            ; Load the value at the selected tile address

    LD R2, EMPTY              ; Load the value representing an empty tile
    NOT R3, R1                ; Invert the value at the tile
    ADD R3, R3, #1            ; Add 1 to the inverted value (2's complement)
    ADD R3, R3, R2            ; Add inverted value and EMPTY
    BRZ TILE_AVAILABLE        ; Branch if tile is empty

    ; Tile is not available
    AND R3, R3, #0            ; Set R3 to 0 (tile not available)
    ST R3, TILE_STATUS        ; Store the status (0) in TILE_STATUS
    RET

TILE_AVAILABLE
    AND R3, R3, #0
    ADD R3, R3, #1
    ST R2, SELECTED_COLUMN
    ST R3, TILE_STATUS        ; Store the status (1) in TILE_STATUS
    RET

SET_TILE
    LD R1, SELECTED_TILE_ADDR ; Load the address of the selected tile
    STR R0, R1, #0            ; Store the value in R0 (PLAYER, AI, or EMPTY) at the selected tile address
    RET

REF_TEMP_ADDR .FILL TEMP_ADDR
REF_PLAYER .FILL PLAYER
REF_AI .FILL AI
REF_EMPTY .FILL EMPTY
; Print Tile Icon Subroutine
; R0 is used to pass the address of the tile
PRINT_TILE_ICON
    ST R0, TEMP_ADDR
    LDI R2, TEMP_ADDR     ; Load the value of the tile (pointed by R0)
    LD R3, PLAYER         ; Load the value representing the player
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted player value (2's complement)
    ADD R2, R2, R3        ; Compare tile with player
    BRZ PRINT_PLAYER_ICON ; Branch if tile is owned by player
    LD R3, AI             ; Load the value representing the AI
    NOT R3, R3            ; Invert for comparison
    ADD R3, R3, #1        ; Add 1 to the inverted AI's value for 2's complement
    ADD R2, R2, R3        ; Compare tile with AI
    BRZ PRINT_AI_ICON     ; Branch if tile is owned by AI
    LEA R0, EMPTY_ICON    ; Load the address of empty icon
    BRNZP PRINT_ICON      ; Go to print the icon

PRINT_PLAYER_ICON
    LEA R0, PLAYER_ICON   ; Load the address of player icon
    BR PRINT_ICON         ; Go to print the icon

PRINT_AI_ICON
    LEA R0, AI_ICON       ; Load the address of AI icon

PRINT_ICON
    PUTS                  ; Print the icon
    RET                   ; Return from subroutine

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

    LD R0, REF_TILE_A1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_A2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_A3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row B
    LD R0, REF_START_ROW_B
    PUTS

    LD R0, REF_TILE_B1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_B2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_B3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS


    ; middle
    LD R0, REF_ROW_DIVIDER
    PUTS

    ; Print Row C
    LD R0, REF_START_ROW_C
    PUTS

    LD R0, REF_TILE_C1
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_C2
    JSR PRINT_TILE_ICON

    LD R0, REF_MID_ROW
    PUTS

    LD R0, REF_TILE_C3
    JSR PRINT_TILE_ICON

    LD R0, REF_END_ROW
    PUTS

    JSR PRINT_NEW_LINE

    ; Pop R7 off the stack
    LDR R7, R6, #0   ; Load R7 from the stack
    ADD R6, R6, #1   ; Increment stack pointer

    RET
