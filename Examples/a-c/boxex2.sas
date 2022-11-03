/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: BOXEX2                                              */
/*   TITLE: Documentation Examples 2 through 6 for PROC BOXPLOT */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: boxplots                                            */
/*   PROCS: BOXPLOT                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC BOXPLOT, Examples 2 through 6                  */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Times;
   informat Day date7. ;
   format   Day date7. ;
   input Day @ ;
   do Flight=1 to 25;
      input Delay @ ;
      output;
   end;
   datalines;
16DEC88   4  12   2   2  18   5   6  21   0   0
          0  14   3   .   2   3   5   0   6  19
          7   4   9   5  10
17DEC88   1  10   3   3   0   1   5   0   .   .
          1   5   7   1   7   2   2  16   2   1
          3   1  31   5   0
18DEC88   7   8   4   2   3   2   7   6  11   3
          2   7   0   1  10   2   3  12   8   6
          2   7   2   4   5
19DEC88  15   6   9   0  15   7   1   1   0   2
          5   6   5  14   7  20   8   1  14   3
         10   0   1  11   7
20DEC88   2   1   0   4   4   6   2   2   1   4
          1  11   .   1   0   6   5   5   4   2
          2   6   6   4   0
21DEC88   2   6   6   2   7   7   5   2   5   0
          9   2   4   2   5   1   4   7   5   6
          5   0   4  36  28
22DEC88   3   7  22   1  11  11  39  46   7  33
         19  21   1   3  43  23   9   0  17  35
         50   0   2   1   0
23DEC88   6  11   8  35  36  19  21   .   .   4
          6  63  35   3  12  34   9   0  46   0
          0  36   3   0  14
24DEC88  13   2  10   4   5  22  21  44  66  13
          8   3   4  27   2  12  17  22  19  36
          9  72   2   4   4
25DEC88   4  33  35   0  11  11  10  28  34   3
         24   6  17   0   8   5   7  19   9   7
         21  17  17   2   6
26DEC88   3   8   8   2   7   7   8   2   5   9
          2   8   2  10  16   9   5  14  15   1
         12   2   2  14  18
;

proc means data=Times noprint;
   var Delay;
   by Day;
   output out=Cancel nmiss=ncancel;
run;

data Times;
   merge Times Cancel;
   by Day;
run;

data Weather;
   informat Day date7. ;
   format   Day date7. ;
   length Reason $ 16 ;
   input Day Flight Reason & ;
   datalines;
16DEC88  8   Fog
17DEC88  18  Snow Storm
17DEC88  23  Sleet
21DEC88  24  Rain
21DEC88  25  Rain
22DEC88  7   Mechanical
22DEC88  15  Late Arrival
24DEC88  9   Late Arrival
24DEC88  22  Late Arrival
;

data Times;
   merge Times Weather;
   by Day Flight;
run;

ods graphics off;
symbol1 value=dot            c=salmon h=3 pct;
symbol2 value=squarefilled   c=vigb   h=3 pct;
symbol3 value=trianglefilled c=vig    h=3 pct;
title 'Box Plot for Airline Delays';
proc boxplot data=Times;
   plot Delay*Day = ncancel /
       nohlabel
       symbollegend = legend1;
   legend1 label = ('Cancellations:');
   label Delay = 'Delay in Minutes';
run;
goptions reset=symbol;

/* Example 3 */

ods graphics on;
title 'Analysis of Airline Departure Delays';
title2 'BOXSTYLE=SKELETAL';
proc boxplot data=Times;
   plot Delay*Day /
      boxstyle = skeletal
      odstitle = title
      nohlabel;
   label Delay = 'Delay in Minutes';
run;

title 'Analysis of Airline Departure Delays';
title2 'BOXSTYLE=SCHEMATIC';
proc boxplot data=Times;
   plot Delay*Day /
      boxstyle = schematic
      odstitle = title
      nohlabel;
   label Delay = 'Delay in Minutes';
run;

title 'Analysis of Airline Departure Delays';
title2 'BOXSTYLE=SCHEMATICID';
proc boxplot data=Times;
   plot Delay*Day /
      boxstyle  = schematicid
      odstitle  = title
      odstitle2 = title2
      nohlabel;
   id Reason;
   label Delay = 'Delay in Minutes';
run;

title 'Analysis of Airline Departure Delays';
title2 'BOXSTYLE=SCHEMATICIDFAR';
proc boxplot data=Times;
   plot Delay*Day /
      boxstyle = schematicidfar
      odstitle  = title
      odstitle2 = title2
      nohlabel;
   id Reason;
   label Delay = 'Delay in Minutes';
run;

/* Example 4 */

proc boxplot data=Times;
   plot Delay*Day /
      boxstyle  = schematicid
      odstitle  = title
      odstitle2 = title2
      nohlabel
      notches;
   id Reason;
   label Delay = 'Delay in Minutes';
run;

/* Example 5 */

data Times2;
   label Delay = 'Delay in Minutes';
   informat Day date7. ;
   format   Day date7. ;
   input Day @ ;
   do Flight=1 to 25;
      input Delay @ ;
      output;
   end;
   datalines;
01MAR90   12  4   2   2  15   8   0  11   0   0
          0  12   3   .   2   3   5   0   6  25
          7   4   9   5  10
02MAR90   1   .   3   .   0   1   5   0   .   .
          1   5   7   .   7   2   2  16   2   1
          3   1  31   .   0
03MAR90   6   8   4   2   3   2   7   6  11   3
          2   7   0   1  10   2   5  12   8   6
          2   7   2   4   5
04MAR90  12   6   9   0  15   7   1   1   0   2
          5   6   5  14   7  21   8   1  14   3
         11   0   1  11   7
05MAR90   2   1   0   4   .   6   2   2   1   4
          1  11   .   1   0   .   5   5   .   2
          3   6   6   4   0
06MAR90   8   6   5   2   9   7   4   2   5   1
          2   2   4   2   5   1   3   9   7   8
          1   0   4  26  27
07MAR90   9   6   6   2   7   8   .   .  10   8
          0   2   4   3   .   .   .   7   .   6
          4   0   .   .   .
08MAR90   1   6   6   2   8   8   5   3   5   0
          8   2   4   2   5   1   6   4   5  10
          2   0   4   1   1
;

title 'Analysis of Airline Departure Delays';
title2 'Using the BOXWIDTHSCALE= Option';
proc boxplot data=Times2;
   plot Delay*Day /
      boxstyle      = schematic
      odstitle      = title
      odstitle2     = title2
      boxwidthscale = 1
      nohlabel
      bwslegend;
run;

/* Example 6 */

proc boxplot data=Times;
   plot Delay*Day /
      boxstyle = schematic
      horizontal;
   label Delay = 'Delay in Minutes';
run;
