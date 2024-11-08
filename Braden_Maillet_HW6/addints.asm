addnms: lodd binum1:               ; this is where you would go to add the binums
        addd binum2:
        stod temp:                 ; temp holds sum
        stod sum:                  ; saves final sum
        lodd on:                  ; print line for formatting**************
        stod 4095
        call xbsywt:            ; checks if
        loco str3:
        call print:             ;***********
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
        call print:
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
        jzer PRINTN:
        jump REGCSE:
sum:        0
temp:       0
cN:        -1
ovrflwflg: 0
mask:      10
rmdr:      0