#!/usr/bin/expect
spawn lc3-simulator MAIN_run-me.obj
expect "Executed 0 instructions"
send "run\r"
expect "abc"
send "B3"
expect "abc"
# expect "Executed 100 instructions"
expect eof