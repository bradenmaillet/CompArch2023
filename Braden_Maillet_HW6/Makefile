run: mya.exe
	./mic1 prom_mrd.dat mya.exe 0 1024
run-o: linker main.obj writeint.obj writestr.obj addints.obj rbsywt.obj xbsywt.obj
	./linker -o main.obj writeint.obj writestr.obj addints.obj rbsywt.obj xbsywt.obj > cons_link.obj
mya.exe:linker main.o writeint.o writestr.o addints.o rbsywt.o xbsywt.o
	./linker main.o writeint.o writestr.o addints.o rbsywt.o xbsywt.o > mya.exe
main.o:
	./masm_mrd1 -o <main.asm> main.o
main.obj:
	./masm_mrd1 -o <main.asm> main.obj
writeint.o:
	./masm_mrd1 -o <writeint.asm> writeint.o
writeint.obj:
	./masm_mrd1 -o <writeint.asm> writeint.obj
writestr.o:
	./masm_mrd1 -o <writestr.asm> writestr.o
writestr.obj:
	./masm_mrd1 -o <writestr.asm> writestr.obj
addints.o:
	./masm_mrd1 -o <addints.asm> addints.o
addints.obj:
	./masm_mrd1 -o <addints.asm> addints.obj
rbsywt.o:
	./masm_mrd1 -o <rbsywt.asm> rbsywt.o
rbsywt.obj:
	./masm_mrd1 -o <rbsywt.asm> rbsywt.obj
xbsywt.o:
	./masm_mrd1 -o <xbsywt.asm> xbsywt.o
xbsywt.obj:
	./masm_mrd1 -o <xbsywt.asm> xbsywt.obj
linker:
	gcc linker.c -o linker
clean:
	rm linker *.o *.obj mya.exe cons_link.obj