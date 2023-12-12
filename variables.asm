; VARIABLES
;
; Input variables
PLAYER_ROW    .BLKW 1    ; Raw input for player row    (ASCII)
PLAYER_COLUMN .BLKW 1    ; Raw input for player column (ASCII)

SELECTED_ROW .BLKW 1      ; Latest inputed row number
SELECTED_COLUMN .BLKW 1  ; Latest inputed column number

SELECTED_TILE_ADDR .FILL #0 ; The tile address that the Player/AI selected to place a tile
TILE_STATUS .FILL #0

; Gameboard tiles
; Each tile can be 0 (empty), 1 (player 1), or 2 (player 2/AI)
TILE_A1 .FILL #1
TILE_A2 .FILL #0
TILE_A3 .FILL #0
TILE_B1 .FILL #0
TILE_B2 .FILL #0
TILE_B3 .FILL #0
TILE_C1 .FILL #0
TILE_C2 .FILL #0
TILE_C3 .FILL #0
; Helper Variable
TEMP_ADDR .FILL #0    ; Temporary storage for loading registers easily
STACK_PTR .FILL xFDFF

; CONSTANTS
;
; Game Constants
PLAYER  .FILL #1
AI      .FILL #2
EMPTY   .FILL #0
; Output Constants
PLAYER_ICON .STRINGZ "X"
AI_ICON .STRINGZ "O"
EMPTY_ICON .STRINGZ " "
; Input constants
ROW_A   .STRINGZ "A"
ROW_B   .STRINGZ "B"
ROW_C   .STRINGZ "C"
COL_1   .STRINGZ "1"
COL_2   .STRINGZ "2"
COL_3   .STRINGZ "3"


