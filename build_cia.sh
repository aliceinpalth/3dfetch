#!/bin/sh

if [[ $1 == "clean" ]]; then
	rm 3dfetch.cia banner.bnr icon.icn romfs.bin 2> /dev/null;
	echo "Clean!";
	exit $?; 
fi

3dstool -cvtf romfs romfs.bin --romfs-dir romfs/
if [[ $? != 0 ]]; then echo "romfs.bin failed to recompile"; exit $?; else echo "romfs.bin recompiled"; fi

bannertool makebanner -i banner.png -a jingle.wav -o banner.bnr
if [[ $? != 0 ]]; then echo "Failed to create banner"; exit $?; else echo "Created banner"; fi

bannertool makesmdh -s "3dfetch" -l "3dfetch" -p "yyualice" -i icon.png -o icon.icn
if [[ $? != 0 ]]; then echo "Failed to create icon"; exit $?; else echo "Created icon"; fi

makerom -f cia -o 3dfetch.cia -DAPP_ENCRYPTED=false -rsf 3dfetch.rsf -target t -exefslogo -elf lpp-3ds.elf -icon icon.icn -banner banner.bnr -romfs romfs.bin
if [[ $? != 0 ]]; then echo "Failed to build CIA"; exit $?; else echo "CIA built"; fi

echo "Done!"

