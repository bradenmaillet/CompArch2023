Name: Braden Maillet
Email: Braden_Maillet@student.uml.edu

Level of success: 100%

Description: 
    This program acts as a linker for the mic-1 assembly language. It takes a multitude of files, beginning with
    a main file, and combines them into one file with many "uncooked" commands. Simultaneously creates a symbol table
    that includes all of the symbols involved in the program along with their addresses. Following this it resolves the uncooked
    instructions with the correct addresses based on the symbol table.
C-code:
    The c-code is mostly the starter code the only thing that I changed was the add_table function. It basically just pushes
    a link onto a linked list and that is all. I also added a print table function for debugging. I also had to add some 
    features to allow for the -o option when linking the program.

Makefile notes:
     make run: runs the program that was made in HW5.
     make run-o: links programs with -o to create a object.
     make clean: cleans the program.