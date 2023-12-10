


; Register claimed:
; R0: Use for passing input/output back and forth between our game

; Manage taking input, validating it, and using it in the rest of our code


; request_input
	; request the user to input something


; get_letter subroutine
	; Read 1 character and verify that it is A, B, or C
	; set value to register if the value is correct, and return
	; Print if the user inputs a bad value
	; loop back to get_letter

; get_number subroutine
	; Read 1 character and verify that it is 1, 2, or 3
	; set value to register if the value is correct, and return
	; Print if the user inputs a bad value
	; loop back to get_letter