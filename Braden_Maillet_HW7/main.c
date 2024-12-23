#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>
#include <sys/wait.h>

int main(void)
{

// some local variables 

        pid_t   pid, ppid;
        int     ruid, rgid, euid, egid;
        int     priority;
        char    msg_buf[75];
        char    temp_buf[100];
        int     msg_pipe[2];

// use the pipe() system call to create the pipe

        if(pipe(msg_pipe) == -1){
                perror("failed in Parent pipe creation:");
                exit(7);
        }

// use various system calls to collect and print process details

        printf("\nThis is the Parent process report:\n");
        pid  = getpid();
        ppid = getppid();
        ruid = getuid();
        euid = geteuid();
        rgid = getgid();
        egid = getegid();
        priority = getpriority(PRIO_PROCESS, 0);

        printf("\nPARENT PROG:  Process ID is:\t\t%d\n\
PARENT PROC:  Process parent ID is:\t%d\n\
PARENT PROC:  Real UID is:\t\t%d\n\
PARENT PROC:  Real GID is:\t\t%d\n\
PARENT PROC:  Effective UID is:\t\t%d\n\
PARENT PROC:  Effective GID is:\t\t%d\n\
PARENT PROC:  Process priority is:\t%d\n",
	pid, ppid, ruid, rgid, euid, egid, priority);

	printf("\nPARENT PROC: will now create child, write pipe,\n \
and do a normal termination\n");

// use the sprintf() call to build a message to write into the pipe
// and dont forget to write the message into the pipe before parent exits
        sprintf(temp_buf,"This is the pipe message from the parent with PID %d" , pid);
// now use the fork() call to create the child:
//
// format is:
//
 	switch (pid = fork()){
        case -1: // if the call fails
                printf("fork call failed\n");
                exit(-1);
        default: // this is the parent's case  
                 // parent must write message to pipe and
                 // do a normal exit
                write(msg_pipe[1], temp_buf, sizeof(temp_buf) + 1);
                exit(0);
        case 0: // this is the child's case
		// child must create and print report
                // child must read pipe message and print 
		// a modified version of it to output
		// child must do a normal exit
                printf("\nPARENT PROG: created Child with %d PID", getpid());
                printf("\nThis is the Child process report:\n");
                pid  = getpid();
                ppid = getppid();
                ruid = getuid();
                euid = geteuid();
                rgid = getgid();
                egid = getegid();
                priority = getpriority(PRIO_PROCESS, 0);

                printf("\nCHILD PROC:  Process ID is:\t\t%d\n\
CHILD PROC:  Process parent ID is:\t%d\n\
CHILD PROC:  Real UID is:\t\t%d\n\
CHILD PROC:  Real GID is:\t\t%d\n\
CHILD PROC:  Effective UID is:\t\t%d\n\
CHILD PROC:  Effective GID is:\t\t%d\n\
CHILD PROC:  Process priority is:\t%d\n",
	        pid, ppid, ruid, rgid, euid, egid, priority);

	                printf("\nCHILD PROG: about to read pipe and report parent message:\n\n");
                        read(msg_pipe[0], msg_buf, 100);
		
		        printf("CHILD PROC: parent's msg is\n\t %s\n\n", msg_buf);
		        printf("CHILD PROC: Process parent ID now is:   %d\n",getppid());
		        printf("CHILD PROC: ### Goodbye ###\n");
                        close(msg_pipe[0]);
                        close(msg_pipe[1]);
		        exit(0);
        } // switch and child end
}


/********************************************************************
This is a typical output from this assignment:


This is the Parent process report:

PARENT PROG:  Process ID is:            15550
PARENT PROC:  Process parent ID is:     26778
PARENT PROC:  Real UID is:              1004
PARENT PROC:  Real GID is:              4000
PARENT PROC:  Effective UID is:         1004
PARENT PROC:  Effective GID is:         4000
PARENT PROC:  Process priority is:      0

PARENT PROC: will now create child, write pipe,
 and do a normal termination

This is the Child process report:

CHILD PROC:  Process ID is:             15551
CHILD PROC:  Process parent ID is:      15550
CHILD PROC:  Real UID is:               1004
CHILD PROC:  Real GID is:               4000
CHILD PROC:  Effective UID is:          1004
CHILD PROC:  Effective GID is:          4000
CHILD PROC:  Process prioroty is:       0

CHILD PROG: about to read pipe and report parent message:

PARENT PROG: created Child with 15551 PID
CHILD PROC: parent's msg is:
      This is the pipe message from the parent with PID 15550

CHILD PROC: Process parent ID now is:   1
CHILD PROC: ### Goodbye ###
*********************************************************************/