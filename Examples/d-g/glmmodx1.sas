/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: GLMMODX1                                            */
/*   TITLE: Example 1 for PROC GLMMOD                           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: GLMMOD, GLM                                         */
/*   PROCS: GLMMOD                                              */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/
data Plants;
   input Type $ @;
   do Block=1 to 3;
      input StemLength @;
      output;
   end;
   datalines;
Clarion  32.7 32.3 31.5
Clinton  32.1 29.7 29.1
Knox     35.7 35.9 33.1
O'Neill  36.0 34.2 31.2
Compost  31.8 28.0 29.2
Wabash   38.2 37.8 31.9
Webster  32.5 31.1 29.7
;
proc glmmod data=Plants outparm=Parm outdesign=Design;
   class Type Block;
   model StemLength = Type|Block;
run;
proc print data=Parm;
run;
proc print data=Design;
run;
