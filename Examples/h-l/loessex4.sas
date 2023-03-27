/****************************************************************/
/*          S A S   S A M P L E   L I B R A R Y                 */
/*                                                              */
/*    NAME: loessex4                                            */
/*   TITLE: Documentation Example 4 for PROC LOESS              */
/* PRODUCT: STAT                                                */
/*  SYSTEM: ALL                                                 */
/*    KEYS: Local Regression                                    */
/*   PROCS: LOESS                                               */
/*    DATA:                                                     */
/*                                                              */
/*     REF:                                                     */
/*    MISC:                                                     */
/****************************************************************/


proc sgplot data=sashelp.ENSO;
   scatter y=Pressure x=Month;
run;

ods graphics on;

proc loess data=sashelp.ENSO plots=residuals(smooth);
   model Pressure=Month;
run;

proc loess data=sashelp.ENSO;
   model Pressure=Month/select=AICC(global);
run;

proc loess data=sashelp.ENSO;
   model Pressure=Month/select=AICC(range(0.03,0.2));
run;

proc loess data=sashelp.ENSO plots=residuals(smooth);
   model Pressure=Month/select=AICC(presearch);
run;

ods graphics off;

