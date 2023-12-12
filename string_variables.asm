
; Gameboard Layout Constants
;     1   2   3
;
; A   X │ X │ O 
;    ───┼───┼───
; B     │ O │   
;    ───┼───┼───
; C   X │   │   
;
COL_LABELS     .STRINGZ "     1   2   3  \n"
ROW_DIVIDER    .STRINGZ "    ───┼───┼─── \n"
MID_ROW        .STRINGZ " │ "
END_ROW        .STRINGZ "  \n"
START_ROW_A    .STRINGZ " A   "
START_ROW_B    .STRINGZ " B   "
START_ROW_C    .STRINGZ " C   "

LOG_WIN  .STRINGZ "\n You Won! \n\n\n"
LOG_TIE  .STRINGZ "\n You both tied, better luck next time \n\n\n"

LOG_EMPTY_LINE  .STRINGZ "\n"
LOG_BOT_THINK_1 .STRINGZ "bzzzz... *Beep* *boop* *zzz* *beep* *zap*"
LOG_BOT_THINK_2 .STRINGZ "*whrrr* *buzzzz* *burp*"
LOG_BOT_THINK_3 .STRINGZ "* you can hear someone quietly typing behind a curtain to your right *"

LOG_BOT_1 .STRINGZ "STARTUP COMPLETE!\n"
LOG_BOT_2 .STRINGZ "Hello,\n"
LOG_BOT_3 .STRINGZ "HELLO AGAIN,\n"
LOG_BOT_4 .STRINGZ "Would you like to play a game of Tic-Tac-Toe?\n"
LOG_BOT_5 .STRINGZ "I SEE YOU HAVE NOT BEEN BEATEN ENOUGH TIMES\n"
LOG_BOT_6 .STRINGZ "HAVE YOU COME BACK FOR MORE PAIN AND MISORY?\n"
LOG_BOT_7 .STRINGZ "HAHA YOU FOOL! PREPARE TO BEATEN AGAIN BY THE GREAT SKYBOT!\n"

LOG_INPUT_1 .STRINGZ "What space would you like to claim?\n"
LOG_INPUT_2 .STRINGZ "Have you come back for more pain and misory? (y/n)\n"

LOG_ERROR_1 .STRINGZ "That is not a valid input, please select a Row and Column using the Letter and Numbers for each column.\nHere are some example inputs:\nA3\nC1\nB2\n\n"
LOG_ERROR_2 .STRINGZ "That space has already been claimed, please select a different one.\n"

LOG_BOT_X .STRINGZ "HAHA?\n"

LOG_INPUT_MOVE   .STRINGZ "Please"
LOG_START_GAME_2 .STRINGZ "HELLO PLAYER,"
LOG_START_GAME_3 .STRINGZ "HELLO PLAYER,"
