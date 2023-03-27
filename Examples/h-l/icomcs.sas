/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: ICOMCS                                              */
/*   TITLE: Convergence Status Example                          */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: ODS Graphics, convergence status                    */
/*   PROCS:                                                     */
/*    DATA:                                                     */
/*                                                              */
/*     REF: SAS/STAT User's Guide, Shared Concepts Chapter      */
/*    MISC:                                                     */
/*                                                              */
/****************************************************************/

/* This example discusses how you can monitor the convergence   */
/* of iterative procedures.                                     */

title 'Convergence Status Example';

data heights;
   input Family Gender $ Height @@;
   datalines;
1 F 67   1 F 66   1 F 64   1 M 71   1 M 72   2 F 63
2 F 63   2 F 67   2 M 69   2 M 68   2 M 70   3 F 63
3 M 64   4 F 67   4 F 66   4 M 67   4 M 67   4 M 69
;

proc mixed data=heights method=ml;
   ods output convergencestatus=cs;
   class Family Gender;
   model Height = Gender Family Family*Gender;
   repeated / type=un subject=family r;
run;

proc print data=cs;
   id status;
run;

proc mixed data=heights method=ml;
   ods output convergencestatus=cs;
   class Family Gender;
   model Height = Gender Family Family*Gender;
   repeated / type=ar(1) subject=family r;
run;

proc print data=cs;
   id status;
run;

