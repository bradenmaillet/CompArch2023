CC = gcc -g
CFLAGS = --std=c99
OBJECTS = CompArchH1.O

all: run

CompArchH1.o:CompArchH1.c
	$(CC) $(FLAGS) -c CompArchH1.c -o CompArchH1.o
run:CompArchH1.o
	$(CC) $(CFLAGS) -o run CompArchH1.o
clean:
	rm run CompArchH1.o
