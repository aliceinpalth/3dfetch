#!/bin/sh
3dstool -cvtf romfs romfs.bin --romfs-dir romfs/
echo "romfs.bin recompiled"
bannertool makebanner -i banner.png -a jingle.wav -o banner.bnr
echo "Created banner"
bannertool makesmdh -s "3dfetch" -l "3dfetch" -p "yyualice" -i icon.png -o icon.icn
echo "Created icon"
makerom -f cia -o 3dfetch.cia -DAPP_ENCRYPTED=false -rsf = 3dfetch.rsf -target t -exefslogo -elf 3dfetch.elf -icon icon.icn -banner banner.bnr -romfs romfs.bin
echo "CIA built"
echo "Done!"