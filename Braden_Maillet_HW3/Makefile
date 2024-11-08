all: ASM run

ASM:
	./masm < rfib.asm > myHW3.obj

run:
	./mic1 prom.dat myHW3.obj 0 2048

clean:
	rm myHW3.obj

