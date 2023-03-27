/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: BOXDET3                                             */
/*   TITLE: Details Example 3 for PROC BOXPLOT                  */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: boxplots                                            */
/*   PROCS: BOXPLOT                                             */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC BOXPLOT, Details Example 3                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

data Newtubes;
   label Diameter='Diameter in mm';
   do Batch = 1 to 15;
      do  i = 1 to 5;
         input Diameter @@;
         output;
      end;
   end;
   datalines;
69.13  69.83  70.76  69.13  70.81
85.06  82.82  84.79  84.89  86.53
67.67  70.37  68.80  70.65  68.20
71.71  70.46  71.43  69.53  69.28
71.04  71.04  70.29  70.51  71.29
69.01  68.87  69.87  70.05  69.85
50.72  50.49  49.78  50.49  49.69
69.28  71.80  69.80  70.99  70.50
70.76  69.19  70.51  70.59  70.40
70.16  70.07  71.52  70.72  70.31
68.67  70.54  69.50  69.79  70.76
68.78  68.55  69.72  69.62  71.53
70.61  70.75  70.90  71.01  71.53
74.62  56.95  72.29  82.41  57.64
70.54  69.82  70.71  71.05  69.24
;

ods graphics on;
title 'Box Plot for New Copper Tubes' ;
proc boxplot data=Newtubes;
   plot Diameter*Batch / odstitle = title;
run;

title 'Box Plot for New Copper Tubes' ;
proc boxplot data=Newtubes;
   plot Diameter*Batch /
      odstitle   = title
      clipfactor = 1.5;
run;

title 'Box Plot for New Copper Tubes' ;
proc boxplot data=Newtubes;
   plot Diameter*Batch /
      odstitle    = title
      clipfactor  = 1.5
      cliplegend  = '# Clipped Boxes'
      clipsubchar = '#';
run;

