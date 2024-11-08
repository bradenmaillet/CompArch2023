CC = gcc -g
CFLAGS = --std=c99
OBJECTS = CompArchH1.O

all: run

main.o:main.c
	$(CC) $(FLAGS) -c main.c -o main.o
run:main.o
	$(CC) $(CFLAGS) -o run main.o
clean:
	rm run main.o
