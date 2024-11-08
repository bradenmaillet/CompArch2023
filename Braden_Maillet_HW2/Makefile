CC = gcc -g
CFLAGS = --std=c99
OBJECTS = CompArchH2.o

all: run

CompArchH2.o:CompArchH2.c
	$(CC) $(FLAGS) -c CompArchH2.c -o CompArchH2.o
run:CompArchH2.o
	$(CC) $(CFLAGS) -o run CompArchH2.o -lm
clean:
	rm run CompArchH2.o
