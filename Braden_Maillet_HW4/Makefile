masm_nr: mic1symasm_nand_rshift.o lex.yy.o
	gcc -o masm_nr mic1symasm_nand_rshift.o lex.yy.o
mic1symasm_nand_rshift.o:  mic1symasm_nand_rshift.c
	gcc -c -g mic1symasm_nand_rshift.c
lex.yy.o:  lex.yy.c
	gcc -c -g lex.yy.c
lex.yy.c: mic1symasm_nand_rshift.ll
	flex mic1symasm_nand_rshift.ll
mc:
	./mcc mic1symasm_nand_rshift.mc > prom_nr.dat
mult:
	./mic1 prom_nr.dat mult_test.obj 0 2000
div:
	./mic1 prom_nr.dat div_test.obj 0 2000
rshift:
	./mic1 prom_nr.dat rshift_test.obj 0 2000
clean:
	rm lex.yy.o lex.yy.c mic1symasm_nand_rshift.o masm_nr prom_nr.dat 
