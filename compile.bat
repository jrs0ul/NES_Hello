ca65 game.s -g -o game.o
ld65 -o game.nes -C memory.cfg game.o --dbgfile game.dbg -Ln game.labels.txt
