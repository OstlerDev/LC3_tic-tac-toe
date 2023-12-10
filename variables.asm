; Constants
PLAYER  .FILL #1
AI      .FILL #2
EMPTY   .FILL #0

; Gameboard tiles
; Each tile can be 0 (empty), 1 (player 1), or 2 (player 2/AI)
TILE_A1 .FILL #0
TILE_A2 .FILL #0
TILE_A3 .FILL #0
TILE_B1 .FILL #0
TILE_B2 .FILL #0
TILE_B3 .FILL #0
TILE_C1 .FILL #0
TILE_C2 .FILL #0
TILE_C3 .FILL #0

; Gameboard Layout Definitions
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
COL_LABELS     .STRINGZ "     1     2     3  \n"
ROW_SPACE      .STRINGZ "        #     #     "
ROW_DIVIDER    .STRINGZ "   #################\n"
MID_ROW        .STRINGZ "  #  "
END_ROW        .STRINGZ "  \n"
START_ROW_A    .STRINGZ " A   "
START_ROW_B    .STRINGZ " B   "
START_ROW_C    .STRINGZ " C   "