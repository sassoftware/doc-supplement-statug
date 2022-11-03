/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: TREGEX3                                             */
/*   TITLE: Documentation Example 3 for PROC TRANSREG           */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: regression analysis, transformations                */
/*   PROCS: TRANSREG                                            */
/*    DATA:                                                     */
/*                                                              */
/*     REF: PROC TRANSREG, EXAMPLE 3                            */
/*    MISC:                                                     */
/****************************************************************/

title 'Atmospheric Pressure Changes Between'
      ' Easter Island & Darwin, Australia';
ods graphics on;

proc transreg data=sashelp.enso;
   model identity(pressure) = pbspline(year);
run;

proc transreg data=sashelp.enso;
   model identity(pressure) = pbspline(year / sbc);
run;

proc transreg data=sashelp.enso;
   model identity(pressure) = pbspline(year / sbc lambda=2 10000 range);
run;

proc transreg data=sashelp.enso;
   model identity(pressure) = pbspline(year / sbc lambda=.1 .5 1 5
                                       10 50 100 500 to 2500 by 500);
run;
