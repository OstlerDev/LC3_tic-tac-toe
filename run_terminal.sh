#!/bin/bash

# Compile our file
./compile.sh

# Add our lc3tools binaries to our path so we can use them in our script
export PATH=$PATH:/Users/sky/Developer/GitHub/lc3tools-master/build/bin

# Remove the old assembled file to make sure we compile a clean version to run
rm MAIN_run-me.obj
# Assemble the file into Binary
lc3-assembler --print-level=6 MAIN_run-me.asm

chmod -x MAIN_run-me.obj
chmod 777 MAIN_run-me.obj

# Run the file in LC3 Simulator
lc3-simulator --print-level=6 MAIN_run-me.obj
# ./run-sim.sh
