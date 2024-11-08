print:  pshi                    ;nextw
        addd c1:
        stod pstr1:
        pop
        jzer crnl1:
        stod 4094
        push
        subd c255a:
        jneg icrnl1:              ; most sig 8 bits are zero
        call sb:
        insp 1
        push
        call xbsywt:
        pop
        stod 4094
        call xbsywt:
        lodd pstr1:
        jump print:
icrnl1:  insp 1                  ; clean up stack before crnl
crnl1:   lodd cr:
        stod 4094
        call xbsywt:
        lodd nl:
        stod 4094
        call xbsywt:
        retn
str2:   "operation resulted in overflow"
str3:   "the sum of these integers is"
c255a:     255
