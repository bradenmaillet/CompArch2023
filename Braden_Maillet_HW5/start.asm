start:  lodd on:                  ; Version contains stack fix for odd-size strings
        stod 4095
        call xbsywt:            ; checks if
        loco str1:
nextw:  pshi
        addd c1:
        stod pstr1:
        pop
        jzer crnl:
        stod 4094
        push
        subd c255:
        jneg icrnl:              ; most sig 8 bits are zero
        call sb:
        insp 1
        push
        call xbsywt:
        pop
        stod 4094
        call xbsywt:
        lodd pstr1:
        jump nextw:
icrnl:  insp 1                  ; clean up stack before crnl
crnl:   lodd cr:
        stod 4094
        call xbsywt:
        lodd nl:
        stod 4094
        call xbsywt:
        lodd on:                ; mic1 program to print string
        stod 4093               ; and scan in a 1-5 digit number
bgndig: call rbsywt:            ; using CSR memory locations
        lodd 4092
        subd numoff:
        push
nxtdig: call rbsywt:
        lodd 4092
        stod nxtchr:
        subd nl:
        jzer endnum:
        mult 10
        lodd nxtchr:
        subd numoff:
        addl 0
        stol 0
        jump nxtdig:
endnum: lodd numptr:
        popi
        addd c1:
        stod numptr:
        lodd numcnt:
        jzer addnms:
        subd c1:
        stod numcnt:
        jump start:                 ;********************************************

addnms: lodd binum1:               ; this is where you would go to add the binums
        addd binum2:
        stod temp:                 ; temp holds sum
        stod sum:                  ; saves final sum
        stod tempfnl:              ; doesnt do anything anymore
        lodd on:                  ; print line for formatting**************
        stod 4095
        call xbsywt:            ; checks if
        loco str3:
nextw3: pshi
        addd c1:
        stod pstr1:
        pop
        jzer crnl3:
        stod 4094
        push
        subd c255:
        jneg icrnl3:              ; most sig 8 bits are zero
        call sb:
        insp 1
        push
        call xbsywt:
        pop
        stod 4094
        call xbsywt:
        lodd pstr1:
        jump nextw3:
icrnl3:  insp 1                  ; clean up stack before crnl
crnl3:   lodd cr:
        stod 4094
        call xbsywt:
        lodd nl:
        stod 4094
        call xbsywt:
        lodd temp:                        ;determine case
        jpos REGCSE:               ; if no overflow detected jump to regular case

OVRFLW: lodd cN:                    ; OVERFLOW CASE
        stod ovrflwflg:             
        loco 0
        stod sum:                  ;dont save sum
        lodd on:                  ; Version contains stack fix for odd-size strings
        stod 4095
        call xbsywt:            ; checks if
        loco str2:
nextw2: pshi
        addd c1:
        stod pstr1:
        pop
        jzer crnl2:
        stod 4094
        push
        subd c255:
        jneg icrnl2:              ; most sig 8 bits are zero
        call sb:
        insp 1
        push
        call xbsywt:
        pop
        stod 4094
        call xbsywt:
        lodd pstr1:
        jump nextw2:
icrnl2:  insp 1                  ; clean up stack before crnl
crnl2:   lodd cr:
        stod 4094
        call xbsywt:
        lodd nl:
        stod 4094
        call xbsywt:
        lodd cN:
        jump reset:

REGCSE: lodd mask:                 ;***************************
        push                       ; push total onto stack for div operation\
        lodd temp:
        push                       ; push mask onto stack
        div
        lodl 0
        stod temp:                 ; sets new value or qout to temp
        lodl 1                     ; 
        addd numoff:               ; remainder to ascii
        stod rmdr:                 ; updated remainder to ascii
        insp 4                     ; clears up stack
        push                       ; push onto stack
        loco 1                     ; increment stack count
        addd stackcnt:  
        stod stackcnt:
        lodd temp:
        jzer PRINT:
        jump REGCSE: 

PRINT:  lodd on:                ; set output on ; print sum
        stod 4095
        call xbsywt:            ; checks if  
RPT:    lodd stackcnt:
        jzer PRNTND:
        subd c1:
        stod stackcnt:
        pop
        stod 4094
        call xbsywt:            
        jump RPT:
PRNTND: lodd nl:
        stod 4094
        call xbsywt:
        lodd cr:
        stod 4094
        call xbsywt:
        loco 0
        jump reset:

reset:  lodd c0:
        stod nxtchr:
        stod binum1:
        stod binum2:
        stod lpcnt:
        stod numcnt:
        stod stackcnt:
        stod pstr1:
        lodd c1:
        stod numcnt:
        loco binum1:
        stod numptr:
        jump start:

xbsywt: lodd 4095
        subd mask:
        jneg xbsywt:
        retn
rbsywt: lodd 4093
        subd mask:
        jneg rbsywt:
        retn
sb:     loco 8          ;swap bite function
loop1:  jzer finish:
        subd c1:
        stod lpcnt:
        lodl 1
        jneg add1:
        addl 1
        stol 1
        lodd lpcnt:
        jump loop1:
add1:   addl 1
        addd c1:
        stol 1
        lodd lpcnt:
        jump loop1:
        halt
finish: lodl 1
        retn

.LOC    300
numoff: 48
nxtchr: 0          ;needs reset
numptr: binum1:    ;needs reset
binum1: 0          ;reset
binum2: 0          ;reset
lpcnt:  0          ;reset
mask:   10    
on:     8 
nl:     10
cr:     13
c0:     0
c1:     1
cN:     -1
c10:    10
c255:   255
sum:    0          
numcnt: 1          ;reset
pstr1:  0          ;reset
temp:   0
tempfnl: 0
rmdr: 0
qout: 0
stackcnt: 0        ;reset
ovrflwflg: 0
str1:   "Please enter a 1-5 digit number followed by enter"
str2:   "operation resulted in overflow"
str3:   "the sum of these integers is"