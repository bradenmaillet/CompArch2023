/**** This is the Mic-1 linker ****/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>

#define HEADERS         1
#define NO_HEADERS      0

typedef struct nament{
        char   name[26];
        int    addr;
        struct nament *next;
}SYMTABENTRY;


void  add_symbol(char * symbol, int line_number);
void  generate_code(int);
void  print_first_pass(int);
void  append_table(void);
void  dump_table(void);
int get_sym_val(char* symbol);
void print_table();

SYMTABENTRY *symtab = NULL;
FILE  *p1, *p2;
char  cstr_12[13];

int main(int argc, char *argv[])
{
	int  i, start, pc_offset=0, pc=0;
	int  linum=0, object_file=0, dump_tab=0;
        int  line_number, new_pc;
	char instruction[18];
	char symbol[26];
	struct timeval randtime;
	char temp_file[20];

/***
	for(i=0; i<argc; i++){
	  printf("arg %d is %s\n", i, argv[i]);
	}
***/

        if(argc > 1 && (strcmp(argv[1], "-s") == 0)) dump_tab = linum = 1;
        else if(argc > 1 && (strcmp(argv[1], "-o") == 0)) object_file = 1;

	if(dump_tab == 1 | object_file == 1)start=2;
	else start = 1; 

	gettimeofday(&randtime, (struct timezone*)0);
	srandom((unsigned int)randtime.tv_usec);
	sprintf(temp_file, "/tmp/bmaillet%d", (unsigned int)random()%10000);

	p1 = fopen(temp_file, "w+");
	unlink(temp_file);

	for(i=start; i<argc; ++i){
		if((p2 = fopen(argv[i], "r")) == NULL){
		  printf("ERROR: cannot open file %s\n", argv[i]);
		  exit(6);
		} 
		while(fscanf(p2,"%d %s", &pc, instruction) != EOF){
		  if(pc == 4096)break;
		  new_pc = pc + pc_offset;
		  symbol[0] = '\0';
		  if(instruction[0] == 'U'){
            	    fscanf(p2, "%s", symbol);
		  }
		  if(object_file){
		    printf("  %d  %s  %s\n", new_pc, instruction, symbol);  //  DEBUG
		  }else{
		    fprintf(p1, "  %d  %s  %s\n", new_pc, instruction, symbol);
		  }
		}
		while(fscanf(p2,"%s %d",symbol, &line_number) != EOF){
		  add_symbol(symbol, line_number+pc_offset);
		}
		pc_offset = new_pc + 1;
		fclose(p2);
	}
	//  print_table();
	generate_code(line_number);
	if(object_file) {
		printf("4096 x\n");
		print_table();
	}
}
void print_table() {
	struct nament *list;
	//  printf("symbol table:\n");
	for(list = symtab; list; list = list->next) {
		printf("  %s%10d\n", list->name, list->addr);
	}
}
void add_symbol(char * symbol, int line_number)
	//  char *symbol;
{
	int i,j;
	struct nament *element, *list;

	if(symtab == NULL) {  //  first case
		symtab = (struct nament*) malloc(sizeof(struct nament));
		strcpy(symtab->name, symbol);
		symtab->addr = line_number;
		symtab->next == NULL;
		return;
	}
	list = symtab;
	while(list->next != NULL) {
		list = list->next;
	}
	list->next = (struct nament*) malloc(sizeof(struct nament));
	list = list->next;
	strcpy(list->name, symbol);
	list->addr = line_number;
	list->next = NULL;

	return;
	/*for(list = symtab; list; list = list->next){
		if((strcmp(list->name, symbol)) == 0){
			list->addr = line_number;
		    return;
			
		}
	}

	fprintf(stderr, "error from symbol table on line %d\n", line_number);
	exit(27);*/
}
void generate_code(int linum){
/****   FILE  *p1;   ****/
	char linbuf[10];
	char instruction[18];
	int  line_number;
	int  pc, mask, sym_val,i, j, old_pc, diff;
	char symbol[26];

	line_number = old_pc = 0;
	rewind(p1);

	sprintf(linbuf,"%5d:  ", line_number);

	while(fscanf(p1,"%d %s", &pc, instruction) != EOF){
	if((diff = pc - old_pc ) > 1){
	  for(j=1; j<diff; j++){
		sprintf(linbuf,"%5d:  ", line_number++);
		printf("%s1111111111111111\n",(linum ? linbuf: "\0"));
	  }
	}
	sprintf(linbuf,"%5d:  ", line_number++);
	old_pc = pc;

	 if(instruction[0] == 'U'){
	   fscanf(p1, "%s", symbol);
	   if((sym_val = get_sym_val(symbol)) == -1){
		fprintf(stderr, "no symbol in symbol table: %s\n", symbol);
		exit(27);
	   }
	   	
           for(i=0; i<12; i++){
	     cstr_12[i] = '0';
	   }
	   cstr_12[12] = '\0';
         
	   mask = 2048;
           for(i=0; i<12; i++){
	      if(sym_val & mask)
		  cstr_12[i] = '1';
	      mask >>= 1;
	   }
	   for(i=0; i<12; i++){
		instruction[i+5] = cstr_12[i];
	   }
	   printf("%s%s\n",(linum ? linbuf: "\0"),&instruction[1]);
	 }else
	   printf("%s%s\n",(linum ? linbuf: "\0"),instruction);
	}
	fclose(p1);
}

void print_first_pass(int headers)
{
        char inbuf[81];

        if(headers == HEADERS){
          printf("\n  FIRST PASS \n");
          rewind(p1);
          while(fgets(inbuf, 80, p1) != NULL){
                printf("   %s", inbuf);
          }
          printf("\n  SECOND PASS \n");
        }else{
          rewind(p1);
          while(fgets(inbuf, 80, p1) != NULL){
                printf("   %s", inbuf);
          }
        }
}

void append_table(void)
{
        struct nament *list;

        printf("  %d %s\n", 4096, "x");
        for(list = symtab; list != NULL; list = list->next){
          printf("    %-25s %4d\n",list->name, list->addr);
        }
}
int get_sym_val(symbol)
	char *symbol;
{
	int i,j;
	struct nament *element, *list;

	for(list = symtab; list != (struct nament *)0; list = list->next){
		if(strcmp(list->name, symbol) == 0){
		   return(list->addr);
		}
	}
	return(-1);
}

/*void dump_table(void){
	FILE *fd;
	struct nament *list;
	fd = popen("sort +0 -1 -f", "w");
	printf("***********************************************\n");
        for(list = symtab; list != (struct nament *)0; list = list->next){
		fprintf(fd,"%-25s %4d\n",list->name, list->addr);
	}
	fclose(fd);
	wait(NULL);
	printf("***********************************************\n");
}*/
