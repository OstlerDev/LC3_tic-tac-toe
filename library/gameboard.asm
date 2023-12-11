

SELECT_TILE
    LEA R4, SELECTED_ROW
    LDR R2, R4, #0          ; Load the selected row
    LEA R4, SELECTED_COLUMN
    LDR R3, R4, #0          ; Load the selected column

    ; Calculate tile address based on row and column
    LEA R4, TILE_A1           ; Load the starting address of tiles
    ADD R2, R2, R2            ; Double the row index (as each row has 3 columns)
    ADD R2, R2, R3            ; Add the column index
    ADD R4, R4, R2            ; Add this offset to the base address
    ST R4, TEMP_ADDR
    LDI R5, TEMP_ADDR         ; Load the value of the selected tile into R5 

    ; R5 now contains the memory address of the selected tile
    ST R5, SELECTED_TILE_ADDR ; Store it for later use
    RET

; Subroutine to check if the selected tile is available
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
    LD R3, #1                 ; Set R3 to 1 (tile available)
    ST R3, TILE_STATUS        ; Store the status (1) in TILE_STATUS
    RET

SET_TILE
    LD R1, SELECTED_TILE_ADDR ; Load the address of the selected tile
    STR R0, R1, #0            ; Store the value in R0 (PLAYER, AI, or EMPTY) at the selected tile address
    RET

PRINT_GAMEBOARD
   ; Print out all of the gameboard text
   RET

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
