PRINTN:  lodd on:                ; set output on ; print sum
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
stackcnt: 0
c0:       0
lpcnt:    0
