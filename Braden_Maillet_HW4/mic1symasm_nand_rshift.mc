0:mar := pc; rd; 				{ main loop  }
1:pc := 1 + pc; rd; 				{ increment pc }
2:ir := mbr; if n then goto 28; 		{ save, decode mbr }
3:tir := lshift(ir + ir); if n then goto 19; 	
4:tir := lshift(tir); if n then goto 11; 	{ 000x or 001x? }
5:alu := tir; if n then goto 9; 		{ 0000 or 0001? }
6:mar := ir; rd; 				{ 0000 = LODD }
7:rd; 						
8:ac := mbr; goto 0; 				
9:mar := ir; mbr := ac; wr; 			{ 0001 = STOD }
10:wr; goto 0; 					
11:alu := tir; if n then goto 15; 		{ 0010 or 0011? }
12:mar := ir; rd; 				{ 0010 = ADDD }
13:rd; 						
14:ac := ac + mbr; goto 0; 			
15:mar := ir; rd; 				{ 0011 = SUBD }
16:ac := 1 + ac; rd; 				{ Note: x - y = x + 1 + not y }
17:a := inv(mbr); 				
18:ac := a + ac; goto 0; 			
19:tir := lshift(tir); if n then goto 25; 	{ 010x or 011x? }
20:alu := tir; if n then goto 23; 		{ 0100 or 0101? }
21:alu := ac; if n then goto 0; 		{ 0100 = JPOS }
22:pc := band(ir, amask); goto 0; 		{ perform the jump }
23:alu := ac; if z then goto 22; 		{ 0101 = JZER }
24:goto 0;					{ jump failed }
25:alu := tir; if n then goto 27; 		{ 0110 or 0111? }
26:pc := band(ir, amask); goto 0; 		{ 0110 = JUMP }
27:ac := band(ir, amask); goto 0; 		{ 0111 = LOCO }
28:tir := lshift(ir + ir); if n then goto 40; 	{ 10xx or 11xx? }
29:tir := lshift(tir); if n then goto 35; 	{ 100x or 101x? }
30:alu := tir; if n then goto 33; 		{ 1000 or 1001? }
31:a := sp + ir; 				{ 1000 = LODL }
32:mar := a; rd; goto 7; 			
33:a := sp + ir; 				{ 1001 = STOL }
34:mar := a; mbr := ac; wr; goto 10; 		
35:alu := tir; if n then goto 38; 		{ 1010 or 1011? }
36:a := sp + ir; 				{ 1010 = ADDL }
37:mar := a; rd; goto 13; 			
38:a := sp + ir; 				{ 1011 = SUBL }
39:mar := a; rd; goto 16; 			
40:tir := lshift(tir); if n then goto 46; 	{ 110x or 111x? }
41:alu := tir; if n then goto 44; 		{ 1100 or 1101? }
42:alu := ac; if n then goto 22; 		{ 1100 = JNEG }
43:goto 0; 					
44:alu := ac; if z then goto 0; 		{ 1101 = JNZE }
45:pc := band(ir, amask); goto 0; 		
46:tir := lshift(tir); if n then goto 50; 	
47:sp := sp + (-1); 				{ 1110 = CALL }
48:mar := sp; mbr := pc; wr; 			
49:pc := band(ir, amask); wr; goto 0; 		
50:tir := lshift(tir); if n then goto 65; 	{ 1111, examine addr }
51:tir := lshift(tir); if n then goto 59; 	
52:alu := tir; if n then goto 56; 		
53:mar := ac; rd; 				{ 1111 000 0 = PSHI }
54:sp := sp + (-1); rd; 			
55:mar := sp; wr; goto 10; 			
56:mar := sp; sp := sp + 1; rd; 		{ 1111 001 0 = POPI }
57:rd; 						
58:mar := ac; wr; goto 10; 			
59:alu := tir; if n then goto 62; 		
60:sp := sp + (-1); 				{ 1111 010 0 = PUSH }
61:mar := sp; mbr := ac; wr; goto 10; 		
62:mar := sp; sp := sp + 1; rd; 		{ 1111 011 0 = POP }
63:rd; 						
64:ac := mbr; goto 0; 				
65:tir := lshift(tir); if n then goto 73; 	
66:alu := tir; if n then goto 70; 		
67:mar := sp; sp := sp + 1; rd; 		{ 1111 100 0 = RETN }
68:rd; 						
69:pc := mbr; goto 0; 				
70:a := ac; 					{ 1111 101 0 = SWAP }
71:ac := sp; 					
72:sp := a; goto 0; 				
73:alu := tir; if n then goto 76; 		
74:a := band(ir, smask); 			{ 1111 110 0 = INSP }
75:sp := sp + a; goto 0; 			
76:tir := tir + tir; if n then goto 80;		
77:a := band(ir, smask); 			{ 1111 111 0 = DESP }
78:a := inv(a); 				
79:a := a + 1; goto 75; 			
80:tir := tir + tir; if n then goto 111;		{ 1111 1111 1 goto check DIV or HALT }  {will need line update}
81:alu := tir + tir; if n then goto 103;         { 1111 1111 01 = RSHIFT }  {will need line update}
82:a := 0;
83:b := 0;
84:c := 0;
85:mar := sp; rd;			{ 1111 1111 00 = MULT start of MULT***********}
86:rd; 
87:a := mbr; if n then goto 95;       {end of grabbing of stack a is op b is mult} {goto negative case}
88:c := 0;                      {sets c to a for loop}
89:b := band(ir, smask);                    {positive case}
90:b := b + (-1); if n then goto 92;        {loop to add} {goto mar := sp}
91:c := c + a; goto 90;             {the line right above} {goto prev line}
92:mar := sp; 
93:mbr := c; wr; if n then goto 102;    {checks if not negative sets to -1} {goto -1 case}
94:ac := 0; wr; goto 0;     
95:b := band(ir, smask);                   {negative case}
96:b := b + (-1); if n then goto 98;        {loop to add} {got 2 line down}
97:c := c + a; goto 96;             {the line right above} {goto line prev}
98:mar := sp; 
99:mbr := c; wr; if n then goto 101;    {checks if negative sets to 0} {goto 0 case}
100:ac := -1; wr; goto 0;
101:ac := 0; wr; goto 0;                {ZERO CASE}
102:ac := -1; wr; goto 0;              {NEG CASE   end of MULT****}
103:a := lshift(1);				{ 1111 1111 01 = RSHIFT ***********}
104:a := lshift(a + 1);
105:a := lshift(a + 1);
106:a := a + 1;
107:b := band(ir, a);        { creating 4 bit mask}
108:b := b + (-1); if n then goto 110;    { loop to shift }
109:ac := rshift(ac); goto 108;
110:goto 0;                 {END OF RSHIFT}
111:tir := tir + tir; if n then goto 171; { 1111 1111 11 goto HALT } {needs to change as written} 
112:a := 0;                                  {1111 1111 10 START DIVIDE *******}
113:mar := sp; rd;
114:c := 0; rd;
115: d := 0;
116: d := sp + 1;
117:a := mbr; {may be sp - 1 im not sure} {save dividend in a}
118:mar := d;rd;
119:b := 0;rd;
120:b := mbr;if n then goto 122;           {save divisor in b} {goto line + 3}
121:d := b; goto 124;                         {goto line + 3}{D is abs of dividend or just b in this case}
122:d := inv(b);                    
123:d := d + 1; goto 124;          {goto line + 1}{save abs of divisor in d}
124:a := a + 0; if n then goto 126;             {goto line + 2}{pass a through alu to test neg}{goto line + 2}
125:c := a; goto 128;                  {C is abs of divisor or just a in this case} {goto line + 3}
126:c := inv(a);                 {c is abs of divisor}
127:c := c + 1;
128:e := 0;             {end of test neg and ABS stuff, ABCD should all be set}
129:e := inv(c);
130:e := e + 1;
131:e := d + e; if n then goto 137;           {check if divisor is greater than dividend d + (-c) or d - c} {goto line + 7}
132:e := sp + (-1);                               {e frees up in prev line}
133:mar := e; mbr := c; wr;                      {remainder = 0}{case that divisor is greater than}
134:e := e + (-1);wr;  {sp + 2}
135:mar := e; mbr := 0;wr;            {qoutient = c or abs of dividend}
136:wr; goto 175;     {end DIV ie div by zero set ac to -1} {*******}
137:d := d + (-1); if n then goto 174;                 {check for divisor = 0} {GOTO ZERO CASE} {START OF NORMAL CASE}
138:a := a + 0; if n then goto 142;{goto aneg}        {TEST A}    {this determines if divisor and dividend are opposite signs}
139:ac := 1;                                {-1 indicates same sign, 1 indicates opposite}
140:b := b + 0; if n then goto 143; {goto OP}     
141:ac := -1; goto 145; {goto start}
142:b:= b + 0; if n then goto 144;    {ANEG}
143:ac := 1; goto 145; {OP} {goto start}
144:ac := -1; goto 145; {SAME} {goto start}                              
145:d := d + 1;             {START}{c := 0 was here may still need to be}{normal case a and b are now free for use, c and d will be used}
146:e := 0;
147:e := e + 1;     {start loop}
148:b := inv(d);
149:b := b + 1;
150:c := c + b;       {c is actually (-d) so c-d}   {subtract dividend - divisor}
151:f := 0;     
152:f := c + b; if n then goto 154;  {goto line + 4}{if divisor becomes bigger than whatever is left of dividend} {remainder in a qoutient in e}
153:goto 147; {repeat loop} {line - 6}   
154:ac := ac + (-1); if z then goto 172; {test op or same}
155:b := 0;             {start of save to stack}
156:b := sp + (-1);
157:mar := b; mbr := c;wr;      {sp - 1 == a which is dividend} {*****}
158:ac := 0;wr;         {save 0 to ac normal case}
159:b := b + (-1);
160:mar := b; mbr := e;wr;      {sp - 2 }
161:wr; goto 168;
162:b := sp + (-1);         {zero case}
163:mar := b; mbr := -1;wr;      
164:wr;
165:b := b + (-1);
166:mar := b; mbr := 0;wr;      
167:wr; goto 168;
168:sp := sp + (-1);           {change stack location}
169:sp := sp + (-1);
170:goto 0;
171:rd; wr;     { 1111 1111 11 = HALT }
172:e := inv(e);        {FLIP RESULT INDICATE OP}
173:e := e + 1; goto 155;      {GOTO SAVE STACK}
174:ac := -1;goto 162;      {set ac to -1 for unusual case} {ZERO CASE}
175:ac := 0; goto 168; {case for divisor greater than dividend}
