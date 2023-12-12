#!/bin/bash

# Merge the files
cat helpers/orig.asm variables.asm main_subroutine.asm library/game.asm library/ai-opponent.asm library/input-output.asm library/helpers.asm library/gameboard.asm string_variables.asm helpers/end.asm > MAIN_run-me.asm

# Assemble and run the merged file in LC-3 Simulator
# Manual step for now