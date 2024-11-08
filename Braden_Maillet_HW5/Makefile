all: obj run

obj:
	./masm_mrd1 <start.asm> start.obj

run:
	./mic1 prom_mrd.dat start.obj 0 2048

clean:
	rm start.obj
