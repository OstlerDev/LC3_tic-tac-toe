

; Store the gameboard in 3 registers,
; one for the player, and one for the opponent, and one for taken tiles
; Breaking it out into multiple registers will allow us to use them as
; "helper" registers to simplify different parts of our code when we
; have to perform checks


; Registers claimed for use by this class:
;
; R1: Gameboard Claimed tiles
; R2: Player 1
; R3:
; 
; example register values:
; R1: 101 010 100
; R2: 100 000 100
; R3: 001 010 000


; Print should look like this:

;          1     2     3
;
;       ###################
;       #     #     #     #
;    A  #  X  #     #  O  #
;       #     #     #     #
;       ###################
;       #     #     #     #
;    B  #     #  O  #     #
;       #     #     #     #
;       ###################
;       #     #     #     #
;    C  #  X  #     #     #
;       #     #     #     #
;       ###################

; subroutine list:
; 
; - print gameboard to console
;    - Make sure to print it with the grid and location markers around the edges (A,B,C 1,2,3)
; 
; - check if tile is taken
; - check who owns the tile
; 
; - claim a tile for the player or opponent
; 
; - check win states for player
; - check win states for ai-opponent
; - check tie states for gameboard