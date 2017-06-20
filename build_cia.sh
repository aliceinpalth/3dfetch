#!/bin/sh
makerom -f cia -target t -desc app:4 -rsf 3dfetch.rs -o 3dfetch.cia -exefslogo -icon icon.png -banner banner.png -elf 3dfetch.elf
echo "cia built"