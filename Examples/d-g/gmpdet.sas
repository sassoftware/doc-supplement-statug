/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: gmpdet                                              */
/*   TITLE: Documentation Details Examples for PROC GLMPOWER    */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: power                                               */
/*          sample size                                         */
/*          power analysis                                      */
/*          error                                               */
/*          info                                                */
/*          information                                         */
/*   PROCS: GLMPOWER                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/


data MyExemp;
   input A $ Y1 Y2;
   datalines;
         1   10 11
         2   12 11
         3   15 11
;

proc glmpower data=MyExemp;
   class A;
   model Y1 Y2 = A;
   power
      stddev = 2
      ntotal = 3 10
      power  = .;
   ods output output=Power;
run;

proc print noobs data=Power;
   var NominalNTotal NTotal Dependent Power Error Info;
run;

