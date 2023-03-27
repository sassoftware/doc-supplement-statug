/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSEX5                                              */
/*   TITLE: Documentation Example 5 for ODS                     */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS                                                 */
/*   PROCS: FREQ                                                */
/*    DATA:                                                     */
/*                                                              */
/*     REF: Using the Output Delivery System                    */
/*    MISC:                                                     */
/****************************************************************/

title 'Hair Color of European Children';

data Color;
   input Region Eyes $ Hair $ Count @@;
   label Eyes  ='Eye Color'
         Hair  ='Hair Color'
         Region='Geographic Region';
   datalines;
1 blue  fair   23  1 blue  red     7  1 blue  medium 24
1 blue  dark   11  1 green fair   19  1 green red     7
1 green medium 18  1 green dark   14  1 brown fair   34
1 brown red     5  1 brown medium 41  1 brown dark   40
1 brown black   3  2 blue  fair   46  2 blue  red    21
2 blue  medium 44  2 blue  dark   40  2 blue  black   6
2 green fair   50  2 green red    31  2 green medium 37
2 green dark   23  2 brown fair   56  2 brown red    42
2 brown medium 53  2 brown dark   54  2 brown black  13
;

ods select none;

proc sort data=Color;
   by Region;
run;

ods output ChiSq=myStats(drop=Table
                         where=(Statistic =: 'Chi' or
                                Statistic =: 'Like'));

proc freq data=Color order=data;
   weight Count;
   tables Eyes*Hair / testp=(30 12 30 25 3);
   by Region;
run;

ods select all;
proc print data=myStats noobs;
run;

