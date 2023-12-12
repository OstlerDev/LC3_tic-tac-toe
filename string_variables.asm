
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

LOG_SELECT_PLAYERS           .STRINGZ "Enter 1 for one-player mode, 2 for two-player mode: "
LOG_INVALID_PLAYER_SELECTION .STRINGZ "\nInvalid input. Please enter 1 or 2.\n"

LOG_PLAYER_1  .STRINGZ "Player 1: "
LOG_PLAYER_2  .STRINGZ "Player 2: "
LOG_PLAYER_AI  .STRINGZ "AI Player: "

LOG_WIN  .STRINGZ "\n You Won! You have bested me, care to push your luck...? \n\n\n"
LOG_LOSS .STRINGZ "\n You LOST, better luck next time!  \n\n\n"
LOG_TIE  .STRINGZ "\n You both tied, maybe give it another try \n\n\n"

LOG_EMPTY_LINE  .STRINGZ "\n"
LOG_BOT_THINK_1 .STRINGZ "bzzzz... *Beep* *boop* *zzz* *beep* *zap*"
LOG_BOT_THINK_2 .STRINGZ "*whrrr* *buzzzz* *burp*"
LOG_BOT_THINK_3 .STRINGZ "* you can hear someone quietly typing behind a curtain to your right *"

LOG_BOT_1 .STRINGZ "STARTUP COMPLETE!\n"
LOG_BOT_2 .STRINGZ "Hello,\n"
LOG_BOT_3 .STRINGZ "HELLO AGAIN,\n"
LOG_BOT_4 .STRINGZ "Would you like to play a game of Tic-Tac-Toe?\n\n"
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

; Data Section
CURRENT_THINKING_STRING .BLKW 1   ; Current string pointer
END_THINKING_STRING     .BLKW 1   ; End of strings marker
THINKING_STRINGS   .STRINGZ "* you can hear someone quietly typing behind a curtain to your right *\n"
                   .STRINGZ "*beep-boop* *scratch-head* *ponder*\n"
                   .STRINGZ "*peek-behind-curtain* *whisper-to-invisible-advisor* *nod-earnestly*\n"
                   .STRINGZ "*shuffle-cards* *peeks-at-hand* shuffles-again*\n"
                   .STRINGZ "*sneak-behind-curtain* *muffled-conversation* *reappear-with-confidence*\n"
                   .STRINGZ "*tap-dance* *spin* *freeze-in-pose*\n"
                   .STRINGZ "*pull-levers-frantically* *look-around-suspiciously* *big-red-button-push*\n"
                   .STRINGZ "*juggle-Xs-and-Os* *oops-drop quick-recover*\n"
                   .STRINGZ "*wizard-hat-on* *wave-magic-wand* *puff-of-smoke*\n"
                   .STRINGZ "*look-left* *look-right* *sneaky-grin*\n"
                   .STRINGZ "*curtain-shuffle* *peek-out-with-one-eye* *quickly-hide-back*\n"
                   .STRINGZ "*mime-pulling-rope* *lean-back* *pull-harder*\n"
                   .STRINGZ "*shadow-puppet-show-behind-curtain* *clap-hands* *take-a-bow*\n"
                   .STRINGZ "*magic-wand-wave* *poof* *confused-glance*\n"
                   .STRINGZ "*conduct-orchestra* *crescendo* *bow*\n"
                   .STRINGZ "*mime-wall-push* *exaggerated-struggle* *wipes-brow*\n"
                   .STRINGZ "*adjust-microphone-behind-curtain* *clear-throat* *silent-announcement*\n"
                   .STRINGZ "*invisible-typewriter* *nod-satisfied* *ding*\n"
                   .STRINGZ "*sift-through-treasure-map* *look-around-confused* *aha-moment*\n"
                   .STRINGZ "*pretend-to-paint* *step-back-admire* *thumb-up*\n"
                   .STRINGZ "*gaze-into-crystal-ball* *mystified-look* *snap-fingers*\n"
                   .STRINGZ "*tug-curtain-cord* *reveal-contraption* *scratch-head-in-confusion*\n"
                   .STRINGZ "*puppeteer-movement* *tangle-in-strings* *untangle-with-a-flourish*\n"
                   .STRINGZ "*simulate-rocket-launch* *countdown* *blast-off*\n"
                   .STRINGZ "*wear-detective-hat* *inspect-with-magnifying-glass* *nod-approvingly*\n"
                   .STRINGZ "*behind-curtain-dance* *curtain-sways-to-music* *curtain-falls-silence*\n"
                   .STRINGZ "*mime-eating-popcorn* *look-at-board-intensely* *popcorn-spill*\n"
                   .STRINGZ "*build-sandcastle* *place-flag-on-top* *admiring-glance*\n"
                   .STRINGZ "*play-invisible-pinball* *hit-flippers* *tilt-alarm*\n"
                   .STRINGZ "*pull-back-curtain-slowly* *reveal-tic-tac-toe-board* *curtain-closes-quickly*\n"
                   .STRINGZ "*pretend-to-surf* *balance-on-board* *wipeout-into-water*\n"
END_THINKING_STRINGS
