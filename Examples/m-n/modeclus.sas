/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: modeclus                                            */
/*   TITLE: Getting Started Example for PROC MODECLUS           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: multivariate analysis, cluster analysis             */
/*   PROCS: MODECLUS, SGPLOT                                    */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC MODECLUS, Getting Started Example              */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data example;
   input x y @@;
   datalines;
18 18  20 22  21 20  12 23  17 12  23 25  25 20  16 27
20 13  28 22  80 20  75 19  77 23  81 26  55 21  64 24
72 26  70 35  75 30  78 42  18 52  27 57  41 61  48 64
59 72  69 72  80 80  31 53  51 69  72 81
;

proc sgplot;
   scatter y=y x=x;
run;

proc modeclus data=example method=1 r=10 15 35 out=out;
run;

proc sgplot data=out noautolegend;
   scatter y=y x=x / group=cluster markerchar=cluster;
   by _r_;
run;

