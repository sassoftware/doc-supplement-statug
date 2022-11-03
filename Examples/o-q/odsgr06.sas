/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ODSGR06                                             */
/*   TITLE: Displaying Graphs Using the DOCUMENT Procedure      */
/* PRODUCT: SAS                                                 */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, ODS document, replaying output        */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data stack;
   input  x1 x2 x3 y @@;
   datalines;
80  27  89  42    80  27  88  37    75  25  90  37
62  24  87  28    62  22  87  18    62  23  87  18
62  24  93  19    62  24  93  20    58  23  87  15
58  18  80  14    58  18  89  14    58  17  88  13
58  18  82  11    58  19  93  12    50  18  89   8
50  18  86   7    50  19  72   8    50  19  79   8
50  20  80   9    56  20  82  15    70  20  91  15
;


/* Creating ODS document */
ods listing close;
ods document name = QQDoc(write);
ods graphics on;

proc robustreg plot=resqqplot data=stack;
   model y = x1 x2 x3;
run;
quit;

ods graphics off;
ods document close;
ods listing;


/* Listing entries in ODS document */
proc document name = QQDoc;
   list / levels = all;
run;
quit;


/* Replaying Q-Q plot */
ods html;   /* On z/OS, replace this with ods html path=".";  */

proc document name = QQDoc;
   replay \Robustreg#1\ResidualQQPlot#1;
run;
quit;

ods html close;
