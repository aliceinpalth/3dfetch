AUTHORS="yyualice & daedreth"
OBJECTS_TO_CLEAN=3ds 3dfetch.cia banner.bnr 3dfetch.smdh romfs.bin 3dfetch.3dsx
CIA_DEPENDENCIES=lpp-3ds.elf romfs.bin banner.bnr 3dfetch.smdh 3dfetch.rsf


3dfetch.cia: ${CIA_DEPENDENCIES}
	makerom -f cia -o $@ -DAPP_ENCRYPTED=false -rsf 3dfetch.rsf -target t -exefslogo -elf lpp-3ds.elf -icon 3dfetch.smdh -banner banner.bnr -romfs romfs.bin

.PHONY: 3dsx
3dsx: 3dfetch.3dsx
	$(info **********  3dsx file built **********)

.PHONY: cia
cia: 3dfetch.cia
	$(info **********  cia file built **********)

3dfetch.3dsx: 3dfetch.smdh
	mkdir -p 3ds/3dfetch
	3dsxtool lpp-3ds.elf $@ --romfs=romfs/ --smdh=$<
	cp $@ 3ds/3dfetch/$@
	cp $< 3ds/3dfetch/$<

romfs.bin: lpp-3ds.elf
	3dstool -cvtf romfs $@ --romfs-dir romfs/

banner.bnr: romfs.bin banner.png jingle.wav
	bannertool makebanner -i banner.png -a jingle.wav -o $@

3dfetch.smdh: banner.bnr icon.png 
	bannertool makesmdh -s "3dfetch" -l "3dfetch" -p ${AUTHORS} -i icon.png -o $@

.PHONY: clean
clean:
	rm -rf ${OBJECTS_TO_CLEAN}
